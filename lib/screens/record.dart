import 'dart:developer';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
import 'package:tt/widegets/widgets.dart';
import '../api/firebase_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class record extends StatefulWidget {
  static String recordRoute = 'record';

  @override
  State<record> createState() => _recordState();
}

class _recordState extends State<record> with TickerProviderStateMixin {
  bool isrecording = false; //display record icon when false
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
  ////////////////////////////////////////////////////////////////
  ///get the path of device storage
  Future<String> getFilePath(String recordName) async {
    Directory dirctory = await getApplicationDocumentsDirectory();
    // audio will be saved here :
    // /data/user/0/com.example.tt/app_flutter
    String path = '${dirctory.path}/$recordName';
    return path;
  }

  bool isRecordingStopped = false;

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

  stop() {
    isRecordingStopped = true;
    setState(() {});

    RecordMp3.instance.stop();
  }

////////play audio with assets player //////////////////
  final assetsAudioPlayer = AssetsAudioPlayer();

  Widget micBtn(String currentMode) {
    return //mic btn
        Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //mic btn
          Container(
              /*    decoration: currentMode == 'dark'
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
         */

              child: !isrecording
                  ?
                  //odd start
                  //mic btn
                  ElevatedButton(
                      onPressed: () {
                        isrecording = true;
                        setState(() {});

                        start();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.mic),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .05,
                          ),
                          Text(
                            AppLocalizations.of(context)!.toRecordPressHere,
                          ),
                        ],
                      ),
                      style: currentMode == 'light'
                          ? lightTheme.btnStyle
                          : DarkTheme.btnStyle,
                    )
                  /*     IconButton(
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
         */ //stop//
                  : ElevatedButton(
                      onPressed: () {
                        isrecording = false;
                        setState(() {});
                        stop();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.stop),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .05,
                          ),
                          Text(
                            AppLocalizations.of(context)!.toStopRecordPressHere,
                          ),
                        ],
                      ),
                      style: currentMode == 'light'
                          ? lightTheme.btnStyle
                          : DarkTheme.btnStyle,
                    )

              /*     IconButton(
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
                      /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  width: MediaQuery.of(context).size.width * .25,
                                  content: Text('record stop and saved')));*/
                    },
                  ),
          */
              ),
        ],
      ),
    );
  }

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
                                PlayedAudioDurationMin =
                                    PlayedAudioDuration!.inMinutes;
                                PlayedAudioDurationSec =
                                    PlayedAudioDuration!.inSeconds;
                                positionMin = position.inMinutes;
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
                                      Text(
                                        '${PlayedAudioDurationMin.toString()}:${PlayedAudioDurationSec.toString()}',
                                        style: GoogleFonts.markaziText(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                color: currentMode == 'light'
                                                    ? lightTheme.LightThemeData
                                                        .accentColor
                                                    : DarkTheme.whiteColor)),
                                      ),
                                      Text(
                                        '${positionMin}:${positionSec}',
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

  static Widget resultNameContainer(String name, String currentMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 15,
        ),
        //mic btn
        Container(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(name,
                style: currentMode == 'light'
                    ? lightTheme.LightThemeData.appBarTheme.toolbarTextStyle!
                        .copyWith(color: Color.fromARGB(157, 133, 7, 7))
                    : DarkTheme.DarkThemeData.appBarTheme.toolbarTextStyle!
                        .copyWith(color: DarkTheme.whiteColor)))
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
            //row contain step container and succsess
            Row(
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
                    ? widgets.success(
                        context, currentMode) //when record is finshed
                    : Container()
              ],
            ),
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
                        AppLocalizations.of(context)!.uploadStepDiscription,
                      ),
                      //mic
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: micBtn(currentMode),
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
                : widgets.verticalLine(context, currentMode, lineHight: 25),

            //step2 section
            isRecordingStopped == true && path != ''
                //if the user start the record then stopped it => path!='' and isrecostop =true
                //then in listen step if the user delete record =? path =='' but isrecstop = true
                ? Column(
                    children: [
                      Center(
                        //contain step2 and success
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: isPredictionCompleted
                                    ? MediaQuery.of(context).size.width * .15
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
                      isPredictionCompleted
                          ? widgets.verticalLine(context, currentMode,
                              lineHight: 25)
                          : Container(),
                    ],
                  )
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
                    resultNameContainer(name, currentMode)
                  ])
                : Container(),
            path != '' && isPredictionCompleted
                ? newPredictBtn(currentMode, currentLang, context)
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
  bool isPredictionCompleted = true;

  String name = 'عبدالباسط عبدالصمد';
  sendToPy(collectedURL) async {
    var firbaseBaseLink =
        'https://firebasestorage.googleapis.com/v0/b/mlflutter-e5a7b.appspot.com/o/files';

    var response = await http
        .get(Uri.parse('${MyApp.baseServerUrl}${collectedURL!.trim()}'));
    if (response.statusCode == 200) {
      isPredictionCompleted = true;
      print(response.body);
      name = response.body;
      if (name == '[1]') {
        name = 'عبدالباسط عبدالصمد';
        setState(() {});
      } else if (name == '[2]') {
        name = 'محمود الحصري';
        setState(() {});
      } else if (name == '[3]') {
        name = 'ماهر المعيقلي';
        setState(() {});
      } else {
        name = 'ناصر القطامي';
        setState(() {});
      }

      print('name $name');
      // var x = jsonDecode(response.body) as Map<String, List<int>>;
      //List<int> result = x['result']!;
      //print(result[0]);

      setState(() {});
    }

    print('url send :$collectedURL');
    print('url download send to python');
    print('response from python ${response.body}');
  }

  Widget newPredictBtn(
      String currentMode, String currentLang, BuildContext context) {
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
          child: Text(AppLocalizations.of(context)!.uploadAgain),
          style: currentMode == 'light'
              ? lightTheme.btnStyle
              : DarkTheme.btnStyle),
    );
  }
}
