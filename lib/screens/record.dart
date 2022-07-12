import 'dart:convert';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:tt/main.dart';
import 'package:tt/myThemeData.dart';
import 'package:http/http.dart' as http;
import 'package:tt/providers/lang_mode.dart';
import 'package:tt/screens/personInfo.dart';
import 'package:tt/widegets/widgets.dart';
import '../api/firebase_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class record extends StatefulWidget {
  static String recordRoute = 'record';

  @override
  State<record> createState() => _recordState();
}

class _recordState extends State<record> with TickerProviderStateMixin {
  late bool hasPermission;
  Future<bool> checkPermission() async {
    await Permission.microphone.request();
    bool hasPermission = await Permission.microphone.isGranted;
    if (hasPermission) {
      print('has permission');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please enable the recording permission')));
    }
    return hasPermission;
  }

  String path = '';
  late DateTime recordName;

  ///get the path of device storage
  Future<String> getFilePath(String recordName) async {
    Directory dirctory = await getApplicationDocumentsDirectory();
    // audio will be saved here :
    // /data/user/0/com.example.tt/app_flutter
    String path = '${dirctory.path}/$recordName';
    return path;
  }

  bool isRecordingStopped = false;
  bool isrecording = false; //display record icon when false
//start record
  start() async {
    print('in start');
    if (await checkPermission()) {
      print('has premission');
      recordName = DateTime.now();
      path = await getFilePath(recordName.toString());
      print('record will be stored is $path');
      isPlaying
          ? print('user cannot record while listining to audio')
          : RecordMp3.instance.start(
              path,
              (error) =>
                  print('from start function there is a error : $error'));
    } else {
      print('user dont have a permission');
    }
  }

//stop record
  stop() {
    isRecordingStopped = true;
    isrecording = false;
    setState(() {});

    RecordMp3.instance.stop();
  }

////////play audio with assets player //////////////////
  final assetsAudioPlayer = AssetsAudioPlayer();

//mic icon and stop record icon
  Widget micBtn(String currentMode) {
    return //mic btn
        Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //mic btn
          Container(
            decoration: currentMode == 'dark'
                ? DarkTheme.btnDecoration.copyWith(
                    //when recording will be red shadow on stop icon
                    boxShadow: [
                      BoxShadow(
                          color: isrecording
                              ? Color.fromARGB(201, 197, 27, 27)
                              : Color.fromARGB(46, 133, 174, 227),
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          //animatimtion
                          blurRadius:
                              isrecording ? 10.0 : 0.0, //tmam//act as lamp
                          spreadRadius: 1.0, //act as border
                          blurStyle: BlurStyle.outer),
                      BoxShadow(
                        color: Color.fromARGB(0, 255, 255, 255),
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  )
                : lightTheme.btnDecoration.copyWith(
                    //when recording will be red shadow on stop icon
                    color: isrecording ? Color(0XFfF6F9EA) : Color(0xff273c57),
                    boxShadow: [
                      BoxShadow(
                          color: isrecording
                              ? Color.fromARGB(201, 197, 27, 27)
                              : Color.fromARGB(46, 133, 174, 227),
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                          //animatimtion
                          blurRadius:
                              isrecording ? 10.0 : 0.0, //tmam//act as lamp
                          spreadRadius: 1.0, //act as border
                          blurStyle: BlurStyle.outer),
                      BoxShadow(
                        color: Color.fromARGB(0, 255, 255, 255),
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
            child: !isrecording
                ?
                //odd start
                //mic btn

                IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: currentMode == 'dark'
                          ? DarkTheme.DarkThemeData.primaryColor
                          : lightTheme.LightThemeData.primaryColor,
                      size: MediaQuery.of(context).size.width * .05,
                    ),
                    onPressed: () async {
                      isrecording = true;
                      setState(() {});

                      start();
                    })
                //stop//
                : IconButton(
                    icon: Icon(
                      Icons.stop,
                      color: Color.fromARGB(201, 219, 44, 44),
                      size: MediaQuery.of(context).size.width * .06,
                    ),
                    onPressed: () async {
                      isrecording = false;
                      //counter = counter + 1;
                      setState(() {});
                      stop();
                      if (currentSecInRecording < 10) {
                        shorterThanTenSec = true;
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

//current length of record
  Widget showStriemRecordDuration(String currentMode) {
    return Container(
      width: MediaQuery.of(context).size.width * .15,
      padding: EdgeInsets.all(10),
      child: StreamBuilder<int>(
        stream: generateNumbers(),
        initialData: 0,
        builder: (
          BuildContext context,
          AsyncSnapshot<int> snapshot,
        ) {
          return Text(snapshot.data.toString(),
              style: currentMode == 'light'
                  ? lightTheme.stepDiscriptionTextStyle.copyWith(shadows: [
                      Shadow(
                          blurRadius: 1, color: Color.fromARGB(85, 93, 10, 10)),
                    ])
                  : DarkTheme.stepDiscriptionTextStyle);
          //   : DarkTheme.lanAndModeSettings);
        },
      ),
    );
  }

  bool oneMinCompleted = false;
  int currentSecInRecording = 0;
//to display record duration during record
  Stream<int> generateNumbers() async* {
    for (int i = 1; i <= 60; i++) {
      await Future<void>.delayed(Duration(seconds: 1));

      yield i;
      print(i);
      currentSecInRecording = i;
      //one min completed 60 sec max duration of record
      if (i == 60) {
        stop();
      }
    }
    ;
  }

  bool shorterThanTenSec = false;
  Widget alertShorterThanTenSec(String currentMode, String currentLang) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width * .8,
          alignment:
              AlignmentGeometry.lerp(Alignment.center, Alignment.center, 4),
          child: Text(
            AppLocalizations.of(context)!.recordShortetThanTen,
            textAlign: TextAlign.center,
            style: currentMode == 'light'
                ? lightTheme.stepDiscriptionTextStyle
                : DarkTheme.lanAndModeSettings,
          ),
        ),
        newPredictBtn(currentMode, currentLang, context)
      ]),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////
////////////////////// end recording functions ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
  bool isPlaying = false;
  Widget playBtn(BuildContext context, String currentMode) {
    return path != ''
        ? Container(
            child: IconButton(
              icon: IconTheme(
                data: currentMode == 'light'
                    ? lightTheme.LightThemeData.iconTheme
                    : DarkTheme.DarkThemeData.iconTheme,
                child: Icon(
                  Icons.play_arrow,

                  /*   color: currentMode == 'light'
                      ? lightTheme.LightThemeData.accentColor
                      : DarkTheme.DarkThemeData.accentColor,
                         */
                  size: MediaQuery.of(context).size.width * .05,
                ),
              ),
              onPressed: () {
                playAudio();
                isPlaying = true;
                setState(() {});

                //enableMiniMusic();
              },
            ),
          )
        : Container();
  }

  Playing? currentAudioPlayed;
  Duration? PlayedAudioDuration;
  int? PlayedAudioDurationMin;
  int? PlayedAudioDurationSec;
  playAudio() {
    assetsAudioPlayer.open(
      Audio.file(path),
    );
    Duration position = assetsAudioPlayer.current.value!.audio.duration;
    // currentAudioPlayed = assetsAudioPlayer.current.value;
    // PlayedAudioDuration = currentAudioPlayed!.audio.duration;
    //  print('hereeeeeeeeeeeeeeeeeeeeeeee ${PlayedAudioDuration}');
    //  PlayedAudioDurationMin = PlayedAudioDuration!.inMinutes;
    //  PlayedAudioDurationSec = PlayedAudioDuration!.inSeconds;
    //  print(currentAudioPlayed!.audio.duration);
    print('in play audio');
    print('duratiiiiiiiiiiiiiiion $position');
    //  currentAudio
  }

  Widget stopBtn(BuildContext context, String currentMode) {
    return Container(
        child: IconButton(
      icon: IconTheme(
        data: currentMode == 'light'
            ? lightTheme.LightThemeData.iconTheme
            : DarkTheme.DarkThemeData.iconTheme,
        child: Icon(
          Icons.pause,
          size: MediaQuery.of(context).size.width * .05,
        ),
      ),
      onPressed: () {
        isPlaying = false;
        stopAudio();
        setState(() {});

        //enableMiniMusic();
      },
    ));
  }

  stopAudio() {
    assetsAudioPlayer.stop();
  }

  int? positionMin;
  int? positionSec;
  Widget listenToAudio(
      BuildContext context, String currentMode, String currentLanguage) {
    return isUploadingFBstart
        ? widgets.waitingPython(context, currentMode,
            AppLocalizations.of(context)!.pleaseWaitDontLeave)
        : Container(
            width: MediaQuery.of(context).size.width * .5,
            child: assetsAudioPlayer.builderIsPlaying(
                builder: (context, isPlaying) {
              return Column(
                children: [
                  !isPlaying
                      ? playBtn(context, currentMode)
                      : stopBtn(context, currentMode),
                  //music
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .05,
                    child: !isPlaying
                        ? widgets.silenceLine(context, currentMode,
                            lineWidth: .15)
                        : widgets.musicLine(context, currentMode, musicNum: 7),
                  ),

                  isPlaying
                      ? Container(
                          //  color: Color.fromARGB(189, 146, 50, 50),
                          width: MediaQuery.of(context).size.width * .3,
                          child: PlayerBuilder.currentPosition(
                              player: assetsAudioPlayer,
                              builder: (context, position) {
                                PlayedAudioDuration = assetsAudioPlayer
                                    .current.value!.audio.duration;
                                //  PlayedAudioDurationMin =PlayedAudioDuration!.inMinutes;
                                PlayedAudioDurationSec =
                                    PlayedAudioDuration!.inSeconds;
                                // positionMin = position.inMinutes;
                                positionSec = position.inSeconds;
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    textDirection: currentLanguage == 'ar'
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //total record duration in sec
                                      Text(
                                        '0:${PlayedAudioDurationSec.toString()}',
                                        style: GoogleFonts.markaziText(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                color: currentMode == 'light'
                                                    ? lightTheme.LightThemeData
                                                        .accentColor
                                                    : DarkTheme.whiteColor)),
                                      ),
                                      //played record duration
                                      Text(
                                        '0:${positionSec}',
                                        style: GoogleFonts.markaziText(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                color: currentMode == 'light'
                                                    ? lightTheme.LightThemeData
                                                        .accentColor
                                                    : DarkTheme.whiteColor)),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      : Container(),

                  !isPredictionCompleted && !isUploadingFBstart
                      //predict and delete
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            deleteBtn(context, currentMode),
                            SizedBox(
                              width: 10,
                            ),
                            predictBtn(context, currentMode)
                          ],
                        )
                      : Container()
                ],
              );
            }),
          );
  }

  Widget deleteBtn(BuildContext context, String currentMode) {
    return path != ''
        ? Container(
            child: ElevatedButton(
            style: lightTheme.btnStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(currentMode == 'light'
                  ? Color.fromARGB(157, 145, 144, 144)
                  : Color.fromARGB(112, 201, 201, 201)),
            ),
            child: IconTheme(
              data: currentMode == 'light'
                  ? lightTheme.LightThemeData.iconTheme
                  : DarkTheme.DarkThemeData.iconTheme,
              child: Icon(
                Icons.delete,
                size: MediaQuery.of(context).size.width * .05,
                color: lightTheme.LightThemeData.primaryColor,
              ),
            ),
            onPressed: () {
              path = '';
              isPredictionCompleted = false;
              isRecordingStopped = false;
              stopAudio();
              setState(() {});

              //enableMiniMusic();
            },
          ))
        : Container();
  }

  Widget predictBtn(BuildContext context, String currentMode) {
    return path != ''
        ? Container(
            child: ElevatedButton(
            style: currentMode == 'light'
                ? lightTheme.btnStyle
                : DarkTheme.btnStyle,
            child: Text(
              AppLocalizations.of(context)!.prdeict,
              style: GoogleFonts.markaziText(
                  fontSize: 18,
                  letterSpacing: 1,
                  color: currentMode == 'light'
                      ? lightTheme.LightThemeData.primaryColor
                      : DarkTheme.DarkThemeData.primaryColor),
            ),
            onPressed: () async {
              await uploadFile();
              sendToPy(collectedURL);
              setState(() {});
            },
          ))
        : Container();
  }

  Widget resultNameContainer(String currentMode, String currentLang) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 15,
        ),
        //mic btn
        Container(
          padding: EdgeInsets.only(left: 15, top: 10),
          width: MediaQuery.of(context).size.width * .8,
          child: Text(
            '$name ($readingType)',
            style: currentMode == 'light'
                ? lightTheme.LightThemeData.appBarTheme.toolbarTextStyle!
                    .copyWith(
                        fontSize: currentLang == 'en' ? 20 : 30,
                        color: Color.fromARGB(157, 133, 7, 7))
                : DarkTheme.DarkThemeData.appBarTheme.toolbarTextStyle!
                    .copyWith(
                        fontSize: currentLang == 'en' ? 20 : 30,
                        color: DarkTheme.whiteColor),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    lang_modeProvider provider = Provider.of(context);
    String currentMode = provider.appMode;
    String currentLang = provider.appLanguage;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            //record
            //row contain recording container and succsess
            !isPredictionCompleted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //when right icon appear the stepcontainer will not be
                      //in center so sized box will make it in center
                      SizedBox(
                        width: path != '' && isRecordingStopped == true
                            ? MediaQuery.of(context).size.width * .15
                            : 0,
                      ),
                      widgets.stepContainer(
                          context, '1', AppLocalizations.of(context)!.record),
                      //should check that recording finished to display
                      //right icon and audio to review
                      isRecordingStopped == true
                          ? shorterThanTenSec
                              ?
                              //warning icon when the record is less than 10 sec
                              Icon(
                                  Icons.warning,
                                  color: currentMode == 'light'
                                      ? Color.fromARGB(230, 255, 0, 0)
                                      : Color.fromARGB(255, 246, 255, 79),
                                  size: MediaQuery.of(context).size.width * .15,
                                )
                              : widgets.success(
                                  context, currentMode) //when record is finshed
                          : Container()
                    ],
                  )
                : Container(),
            //leave space between stepcontainer and mic icon in the first step
            //then disappear in the next steps
            isRecordingStopped == false
                //contain step disc , mic , instructions
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                      //discription text
                      widgets.stepDiscriptionContainer(
                        currentMode,
                        context,
                        AppLocalizations.of(context)!.recordStepDiscription,
                      ),
                      //mic
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Container(
                          width: isrecording
                              ? MediaQuery.of(context).size.width * .8
                              : MediaQuery.of(context).size.width * .5,
                          padding: EdgeInsets.all(12),
                          // color: DarkTheme.whiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              micBtn(currentMode),
                              //space between linear indecator and mic btn
                              SizedBox(
                                width: isrecording
                                    ? MediaQuery.of(context).size.width * 0.05
                                    : MediaQuery.of(context).size.width * 0,
                              ),

                              //display stream for record's duration
                              isrecording
                                  ? showStriemRecordDuration(currentMode)
                                  : Container(),

                              //linear indecator while recording
                              isrecording
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .02,
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                      child: widgets.musicLine(
                                          context, currentMode)
                                      //LinearProgressIndicator()

                                      )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      //instructions
                      Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: widgets
                              .stepInstructionsCoulmn(currentMode, context, [
                            '1- ${AppLocalizations.of(context)!.dontRecordInNoise}',
                            '2- ${AppLocalizations.of(context)!.dontRecordEmptyOrSilence}'
                          ])),
                    ],
                  )
                : !isPredictionCompleted
                    ? widgets.verticalLine(context, currentMode, lineHight: 25)
                    : Container(),
            shorterThanTenSec
                ? alertShorterThanTenSec(currentMode, currentLang)
                :
                //step2 listen to audio
                isRecordingStopped == true && path != ''
                    //if the user start the record then stopped it => path!='' and isrecostop =true
                    //then in listen step if the user delete record =? path =='' but isrecstop = true
                    ? !isPredictionCompleted
                        ? Column(
                            children: [
                              Center(
                                //contain step2 and success
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: isPredictionCompleted
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15
                                            : 0),
                                    widgets.stepContainer(
                                      context,
                                      '',
                                      AppLocalizations.of(context)!.checkAudio,
                                    ),
                                    isPredictionCompleted
                                        ? widgets.success(context, currentMode)
                                        : Container()
                                  ],
                                ),
                              ),
                              !isPredictionCompleted
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: listenToAudio(
                                          context, currentMode, currentLang))
                                  : Container(),
                            ],
                          )
                        : Container()
                    : Container(),

            //result
            isPredictionCompleted && path != ''
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: isPredictionCompleted
                              ? MediaQuery.of(context).size.width * .15
                              : 0),
                      widgets.stepContainer(
                          context, '', AppLocalizations.of(context)!.result),
                      widgets.success(context, currentMode)
                    ],
                  )
                : Container(),
            isPredictionCompleted && path != ''
                ? Column(children: [
                    //  widgets.verticalLine(context, currentMode, lineHight: 30),
                    //widgets.horizontalLine(currentMode),
                    resultNameContainer(currentMode, currentLang),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),

                    namePhoto == 'Abdul-Baset'
                        ? reciterPhoto('images/abdelbaset/1.jpg')
                        : namePhoto == 'Al-Hosry'
                            ? reciterPhoto('images/hosary/1.jfif')
                            : namePhoto == 'Maher'
                                ? reciterPhoto('images/maher/1.png')
                                : reciterPhoto('images/naser/1.jfif'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                  ])
                : Container(),
            path != '' && isPredictionCompleted
                ?
                //predict again and info
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      showProfile(currentMode, currentLang, context),
                      newPredictBtn(currentMode, currentLang, context),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  bool isUploadingFBstart = false;
  String collectedURL = '';
  UploadTask? task;
  Future uploadFile() async {
    if (path == '') return;
    isUploadingFBstart = true;
    setState(() {});
    //final fileName = basename(file!.path);
    final destination = 'records/$recordName';

    task = FirebaseApi.uploadFile(destination, File('$path'));
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    final uploadedAudioName = snapshot.ref.name;

    print('Download-Link: $urlDownload');

    var firbaseBaseLink =
        'https://firebasestorage.googleapis.com/v0/b/mlflutter-e5a7b.appspot.com/o/records';
    collectedURL =
        'downloadUrl=$urlDownload&firbaseBaseLink=$firbaseBaseLink&uploadedAudioName=$uploadedAudioName&fileExtension=mp3';
    sendToPy(collectedURL);
  }

  // var serverBaseLink = 'https://3e96-156-194-125-117.eu.ngrok.io/?';
//  bool isPredictionCompleted = false;
  bool isPredictionCompleted = false;

  String name = '';
  String readingType = '';
  String namePhoto = '';
  sendToPy(collectedURL) async {
    var firbaseBaseLink =
        'https://firebasestorage.googleapis.com/v0/b/mlflutter-e5a7b.appspot.com/o/files';

    var response = await http
        .get(Uri.parse('${MyApp.baseServerUrl}${collectedURL!.trim()}'));
    if (response.statusCode == 200) {
      isPredictionCompleted = true;
      print(response.body);
      var responseMap = jsonDecode(response.body);
      readingType = responseMap['type'];
      name = responseMap['name'];
      namePhoto = name;
      if (name == 'Abdul-Baset') {
        name = AppLocalizations.of(context)!.abdElBasetName;

        setState(() {});
      } else if (name == 'Al-Hosry') {
        name = AppLocalizations.of(context)!.hosaryName;
        setState(() {});
      } else if (name == 'Maher') {
        name = AppLocalizations.of(context)!.maherName;
        setState(() {});
      } else {
        name = AppLocalizations.of(context)!.naserName;
        setState(() {});
      }
      if (readingType == 'Murattal') {
        readingType = AppLocalizations.of(context)!.murratal;
        setState(() {});
      } else {
        readingType = AppLocalizations.of(context)!.mogawad;
        setState(() {});
      }
      print('name $name');
      setState(() {});

      print('url send :$collectedURL');
      print('url download send to python');
      print('response from python ${response.body}');
    }
  }

  Widget reciterPhoto(String imgPath) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(image: AssetImage('$imgPath'))),
      height: MediaQuery.of(context).size.height * .25,
      width: MediaQuery.of(context).size.width * .5,
    );
  }

  Widget newPredictBtn(
      String currentMode, String currentLang, BuildContext context) {
    shorterThanTenSec = false;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
          onPressed: () {
            isPredictionCompleted = false;
            path = '';
            isUploadingFBstart = false;
            isRecordingStopped = false;
            isPlaying = false;
            isrecording = false;
            setState(() {});
          },
          child: Text(AppLocalizations.of(context)!.recordAgain),
          style: currentMode == 'light'
              ? lightTheme.btnStyle
              : ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 25, 85, 162),
                  )),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(210, 123, 43, 43)),
                )),
    );
  }

  Widget showProfile(
      String currentMode, String currentLang, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (__) => personInfo(namePhoto)));
            setState(() {});
          },
          child: Text(AppLocalizations.of(context)!.readMore),
          style: currentMode == 'light'
              ? lightTheme.btnStyle
              : ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 25, 85, 162),
                  )),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(210, 123, 43, 43)),
                )),
    );
  }
}
