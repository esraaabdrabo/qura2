import 'dart:convert';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tt/api/firebase_api.dart';
import 'package:tt/main.dart';
import 'package:tt/providers/lang_mode.dart';
import 'package:tt/screens/personInfo.dart';
import 'package:tt/widegets/widgets.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//AppLocalizations.of(context)!.light,
import '../myThemeData.dart';

class upload extends StatefulWidget {
  static String uploadRoute = 'upload';

  @override
  State<upload> createState() => _uploadState();
}

class _uploadState extends State<upload> {
  String? collectedURL;
  UploadTask? task;
  String path = '';
  File? file;
  String? fileExtension;
  Widget uploadBtn(BuildContext context, String currentMode) {
    return //mic btn
        Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //upload btn
          Container(
              decoration: currentMode == 'dark'
                  ? DarkTheme.btnDecoration
                  : lightTheme.btnDecoration,
              child: IconButton(
                  icon: Icon(
                    Icons.upload,
                    color: currentMode == 'dark'
                        ? DarkTheme.DarkThemeData.primaryColor
                        : lightTheme.LightThemeData.primaryColor,
                  ),
                  onPressed: () async {
                    selectFile();
                  })
              //stop//
              ),
        ],
      ),
    );
  }

  Duration? duration;
  //firest step choose the audio
  Future selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowMultiple: false);
    ///////////////////////////////////////
    if (result == null) return;
    ///////////////////////////////////////
    path = result.files.single.path!;
    fileExtension = result.files.single.extension;

    print('extension $fileExtension');
    setState(() => file = File(path));
    playAudio(0);
    getAudioDuration();
    //testffmpeg();

    /*  var response = await http.get(Uri.parse(
        'https://7445-156-192-176-175.eu.ngrok.io/?bytesList=$bytes'));
    if (response.statusCode == 200) {
      print('success 200');
    } else {
      print('falied ${response.statusCode}');
    }*/

    //Unhandled Exception: SocketException: Broken pipe
    //(OS Error: Broken pipe, errno = 32),
    // address = 2c78-156-192-176-175.eu.ngrok.io, port = 54558
    //cant send the whole list according to its length
  }

  void getAudioDuration() {
    assetsAudioPlayer.current.listen((playingAudio) {
      duration = playingAudio!.audio.duration;
      print('ffrom get ${duration!.inMinutes}');

      if (!shortAudio(duration!.inSeconds)) {
        longAudio(duration!.inSeconds);
      }
    });
  }

  bool isShortAudio = false;
  bool shortAudio(int durationInSec) {
    //sec < 10
    if (durationInSec < 10) {
      isShortAudio = true;
      setState(() {});
      print('audio cant be less than 10 we have : $durationInSec sec');
    } else {
      print('audio more than 10 sec we have : $durationInSec sec');
    }
    return false;
  }

  Widget alertShorterThanTenSec(
      BuildContext context, String currentMode, String currentLang) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width * .8,
          alignment:
              AlignmentGeometry.lerp(Alignment.center, Alignment.center, 4),
          child: Text(
            isShortAudio
                ? AppLocalizations.of(context)!.recordShortetThanTen
                : AppLocalizations.of(context)!.recordLongerThanOneMin,
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

  bool isLongAudio = false;
  bool longAudio(int durationInSec) {
    if (durationInSec > 60) {
      isLongAudio = true;
      setState(() {});
      // testffmpeg();
      print('audio cant be more than 1 min we have : $durationInSec min');
    } else {
      print('audio more than 10 sec and less than 1 min (no problem) ');
    }
    return false;
  }

  Widget alertLongerThanOneMin(
      BuildContext context, String currentMode, String currentLang) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width * .8,
          alignment:
              AlignmentGeometry.lerp(Alignment.center, Alignment.center, 4),
          child: Text(
            isShortAudio
                ? AppLocalizations.of(context)!.recordShortetThanTen
                : AppLocalizations.of(context)!.recordLongerThanOneMin,
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

  void testffmpeg() async {
    Directory dirctory = await getApplicationDocumentsDirectory();
    String newpath1 = '${dirctory.path}';
    print(dirctory.absolute);
    String cuttedAudioPath = '/data/user/0/com.example.tt/cache/file_picker';
    String newName = DateTime.now().toString().replaceAll(RegExp(r' '), '');

    ///////////////////work cmd///////////////////
    /// cut audio from 4 sec to 10 sec
    //  "-i $path -ss 00:00:4 -to 00:00:10 -c copy   $newpath1/$cuttedAudio.$fileExtension";
    var cmd =
        "-i $path -ss 00:00:4 -to 00:00:10 -c copy   $cuttedAudioPath/$newName.mp3";

    ///    data/user/0/com.example.tt/app_flutter/new.mp3
    await FFmpegKit.execute(cmd).then((value) async {
      ReturnCode? returnCode = await value.getReturnCode();
      print(await value.getState());
      setState(() {});
      print("returnCode $returnCode");
    });

    assetsAudioPlayer.open(Audio.file('$cuttedAudioPath/$newName.mp3'),
        showNotification: true);
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////end pre proccessing///////////////////////////

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  bool isPlaying = false; //display record icon when false

  Widget playBtn(BuildContext context, String currentMode) {
    return path != ''
        ? Container(
            //  margin: EdgeInsets.only(top: 15),
            child: IconButton(
              icon: IconTheme(
                data: currentMode == 'light'
                    ? lightTheme.LightThemeData.iconTheme
                    : DarkTheme.DarkThemeData.iconTheme,
                child: Icon(
                  Icons.play_arrow,
                  size: MediaQuery.of(context).size.width * .05,
                ),
              ),
              onPressed: () {
                print(isShortAudio);
                print(isLongAudio);
                playAudio(10.0);
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

  playAudio(double volume) {
    isPlaying = true;
    print('in play audio');
    // await assetsAudioPlayer.setVolume(volume);
    assetsAudioPlayer.open(Audio.file(path));
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
    isPlaying = false;
    assetsAudioPlayer.stop();

    setState(() {});
  }

  Duration? position;
  int? positionMin;
  int? positionSec;
  Widget listenToAudio(
      BuildContext context, String currentMode, String currentLanguage) {
    return isUploadingFBstart
        ? isConnectionError != true
            ? widgets.waitingPython(
                context,
                currentMode,
                AppLocalizations.of(context)!.pleaseWaitDontLeave,
              )
            : Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'check your connection',
                    style: GoogleFonts.markaziText(
                        textStyle: TextStyle(
                            fontSize: 30,
                            color: currentMode == 'light'
                                ? lightTheme.LightThemeData.accentColor
                                : DarkTheme.whiteColor)),
                  ),
                ),
              )
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
                                        '0:${PlayedAudioDurationSec.toString()}',
                                        style: GoogleFonts.markaziText(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                color: currentMode == 'light'
                                                    ? lightTheme.LightThemeData
                                                        .accentColor
                                                    : DarkTheme.whiteColor)),
                                      ),
                                      Text(
                                        '0:${positionSec}',
                                        style: GoogleFonts.markaziText(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                color: currentMode == 'light'
                                                    ? lightTheme.LightThemeData
                                                        .accentColor
                                                    : DarkTheme.whiteColor)),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      : Container(),
                  !isPredictionCompleted
                      //predict and delete
                      ? !isShortAudio && !isLongAudio
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
                          : alertShorterThanTenSec(
                              context, currentMode, currentLanguage)
                      : Container(),
                ],
              );
            }),
          );
    /*Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              // color: Color(0xff273c57),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  !isPlaying
                      ? widgets.silenceLine(context, lineWidth: .15)
                      : widgets.musicLine(context, musicNum: 4),
                ],
              ),
            ),
            SizedBox(
              width: 50,
            ),
            !isPlaying ? playBtn(context) : stopBtn(context),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            deleteBtn(context),
            SizedBox(
              width: 15,
            ),
            predictBtn(context)
          ],
        )
      ],
    );
  */
  }

  bool isPredictionCompleted = false;
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
              isLongAudio = false;
              isShortAudio = false;
              path = '';
              stopAudio();
              setState(() {});
            },
          ))
        : Container();
  }

  bool isUploadingFBstart = false;

  Future uploadFile() async {
    if (file == null) return;
    isUploadingFBstart = true;
    setState(() {});
    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    final uploadedAudioName = snapshot.ref.name;

    print('Download-Link: $urlDownload');

    var firbaseBaseLink =
        'https://firebasestorage.googleapis.com/v0/b/mlflutter-e5a7b.appspot.com/o/files';
    collectedURL =
        'downloadUrl=$urlDownload&firbaseBaseLink=$firbaseBaseLink&uploadedAudioName=$uploadedAudioName&fileExtension=$fileExtension';
  }

//https://firebasestorage.googleapis.com/v0/b/mlflutter-e5a7b.appspot.com/o/files
//%2F(error when convert this to /) will be add in python code
//ebrahem001.wav?
//alt=media&
//token=15ddfe8e-ebf4-4f3b-9b2d-fb1dd3b94df7
//$serverBaseLinkfirbaseBaseLink=$firbaseBaseLink&uploadedAudioName=
//$uploadedAudioName&downloadUrl=$urlDownload
////&fileExtension=mp3 => update in next
  bool isConnectionError = false;
  String name = '';
  String readingType = '';
  String photoname = '';
  String typeCopy = '';
  sendToPy(collectedURL, BuildContext context) async {
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

      photoname = name;
      typeCopy = readingType;
      print('name $name');
      setState(() {});
    } else {
      isConnectionError = true;
      setState(() {});
    }
    print('url send :$collectedURL');
    print('url download send to python');
    print('response from python ${response.body}');
  }

  Widget predictBtn(BuildContext context, String currentMode) {
    return path != ''
        ? Container(
            child: ElevatedButton(
            style: lightTheme.btnStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(currentMode == 'light'
                  ? Color.fromARGB(157, 133, 7, 7)
                  : DarkTheme.DarkThemeData.accentColor),
            ),
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
              if (isPlaying) {
                stopAudio();
              }
              await uploadFile();
              sendToPy(collectedURL, context);
              setState(() {});
            },
          ))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    lang_modeProvider provider = Provider.of(context);
    String currentMode = provider.appMode;
    String currentLanguage = provider.appLanguage;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            //upload
            !isPredictionCompleted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: path != ''
                            ? MediaQuery.of(context).size.width * .15
                            : 0,
                      ),
                      widgets.stepContainer(
                          context, '1', AppLocalizations.of(context)!.upload),
                      path != '' && !isShortAudio && !isLongAudio
                          ? widgets.success(context, currentMode)
                          : //warning icon when the record is less than 10 sec
                          (path != '' && (isShortAudio || isLongAudio))
                              ? Icon(
                                  Icons.warning,
                                  color: currentMode == 'light'
                                      ? Color.fromARGB(230, 255, 0, 0)
                                      : Color.fromARGB(255, 246, 255, 79),
                                  size: MediaQuery.of(context).size.width * .15,
                                )
                              : Container()
                    ],
                  )
                : Container(),
            SizedBox(
              height: path == ''
                  ? MediaQuery.of(context).size.height * .05
                  : MediaQuery.of(context).size.height * 0,
            ),
            path == ''
                ? Column(
                    children: [
                      widgets.stepDiscriptionContainer(
                        currentMode,
                        context,
                        AppLocalizations.of(context)!.uploadStepDiscription,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: uploadBtn(context, currentMode),
                      ),
                      //instructions
                      Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: widgets
                              .stepInstructionsCoulmn(currentMode, context, [
                            '1- ${AppLocalizations.of(context)!.dontUploadEmptyAudio}',
                          ])),
                    ],
                  )
                : !isPredictionCompleted
                    ? widgets.verticalLine(context, currentMode, lineHight: 50)
                    : Container(),

            //step 2 predict or delete
            path != '' && !isPredictionCompleted
                ? Column(
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: isPredictionCompleted
                                    ? MediaQuery.of(context).size.width * .15
                                    : 0),
                            !isShortAudio && !isLongAudio
                                ? widgets.stepContainer(
                                    context,
                                    '',
                                    AppLocalizations.of(context)!.checkAudio,
                                  )
                                : widgets.stepContainer(context, '', "error"),
                            isPredictionCompleted
                                ? widgets.success(context, currentMode)
                                : Container()
                          ],
                        ),
                      ),
                      !isPredictionCompleted
                          ? Container(
                              //color: lightTheme.LightThemeData.accentColor,
                              width: MediaQuery.of(context).size.width,
                              child: listenToAudio(
                                  context, currentMode, currentLanguage))
                          : Container(),
                      isPredictionCompleted
                          ? widgets.verticalLine(context, currentMode,
                              lineHight: 50)
                          : Container(),
                    ],
                  )
                : Container(),

            isPredictionCompleted && path != ''
                ? Column(
                    children: [
                      // widgets.verticalLine(context, lineHight: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: isPredictionCompleted
                                  ? MediaQuery.of(context).size.width * .15
                                  : 0),
                          widgets.stepContainer(context, '',
                              AppLocalizations.of(context)!.result),
                          widgets.success(context, currentMode)
                        ],
                      ),
                      isPredictionCompleted && path != ''
                          ? Column(children: [
                              widgets.verticalLine(context, currentMode,
                                  lineHight: 30),
                              widgets.horizontalLine(currentMode),
                              resultNameContainer(
                                  currentMode, currentLanguage, context),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .04,
                              ),
                              photoname == 'Abdul-Baset'
                                  ? reciterPhoto(
                                      'images/abdelbaset/1.jpg', context)
                                  : photoname == 'Al-Hosry'
                                      ? reciterPhoto(
                                          'images/hosary/1.jfif', context)
                                      : photoname == 'Maher'
                                          ? reciterPhoto(
                                              'images/maher/1.png', context)
                                          : reciterPhoto(
                                              'images/naser/1.jfif', context),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .02,
                              ),
                            ])
                          : Container()
                    ],
                  )
                : Container(),
            path != '' && isPredictionCompleted
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      showProfile(currentMode, currentLanguage, context),
                      newPredictBtn(currentMode, currentLanguage, context),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget resultNameContainer(
      String currentMode, String currentLang, BuildContext context) {
    print('name $name');
    if (photoname == 'Abdul-Baset') {
      name = AppLocalizations.of(context)!.abdElBasetName;

      setState(() {});
    } else if (photoname == 'Al-Hosry') {
      name = AppLocalizations.of(context)!.hosaryName;
      setState(() {});
    } else if (photoname == 'Maher') {
      name = AppLocalizations.of(context)!.maherName;
      setState(() {});
    } else {
      name = AppLocalizations.of(context)!.naserName;
      setState(() {});
    }
    if (typeCopy == 'Murattal') {
      readingType = AppLocalizations.of(context)!.murratal;
      setState(() {});
    } else {
      readingType = AppLocalizations.of(context)!.mogawad;
      setState(() {});
    }
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

  Widget reciterPhoto(String imgPath, BuildContext context) {
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
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
          onPressed: () {
            stopAudio();

            isPredictionCompleted = false;
            path = '';
            isUploadingFBstart = false;
            isShortAudio = false;
            isLongAudio = false;
            setState(() {});
          },
          child: Text(AppLocalizations.of(context)!.uploadAgain),
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
            print(photoname);
            Navigator.push(context,
                new MaterialPageRoute(builder: (__) => personInfo(photoname)));
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
