import 'dart:io';
import 'dart:typed_data';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tt/api/firebase_api.dart';
import 'package:tt/providers/lang_mode.dart';
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

@override
State<upload> createState() => _uploadState();

class _uploadState extends State<upload> {
  static String splashRoute = 'splash';

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

  String bytes = '';
  Future selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowMultiple: false);

    if (result == null) return;
    path = result.files.single.path!;
    fileExtension = result.files.single.extension;
    print('extension $fileExtension');
    setState(() => file = File(path));
    await file!.readAsBytes().then((value) {
      bytes = Uint16List.fromList(value).toString();
      setState(() {
        bytes;
      });
      print('bytttteeeessss $bytes');
    });

    /** Uint8List testbytes = await file!.readAsBytes();
  *  print('bytes is $testbytes');
*
     * [73, 68, 51, 3, 0, 0, 0, 0, 31, 118, 84, 73, 84, 50, 0,
     *  0, 0, 8, 0, 0, 0, 48, 48, 52, 46, 109, 112, 51, 67, 79,
     *  77, 77, 0, 0, 0, 26, 0, 0, 0, 101, 110, 103, 0, 104, 116, 
     * 116, 112, 58, 47, 47, 109, 112, 51, 115, 112, 108, 116, 46,
     *  115, 102, 46, 110, 101, 116, 87, 79, 65, 70, 0, 0, 0, 33,
     *  0, 0, 104, 116, 116, 112, 58, 47, 47, 119, 119, 119, 46,
     *  118, 101, 114, 115, 101, 98, 121, 118, 101, 114, 115, 101,
     *  113, 117, 114, 97, 110, 46, 99, 111, 109, 47, 84, 67, 79, 78,
     *  0, 0, 0, 5, 0, 0, 0, 40, 49, 50, 41, 84, 65, 76, 66, 0, 0, 0,
     *  22, 0, 0, 0, 86, 101, 114, 115, 101, 66, 121, 86, 101, 114, 115,
     *  101, 81, 117, 114, 97, 110, 46, 67, 111, 109, 67, 79, 77, 77, 0,
     *  0, 0, 38, 0, 0, 0, 101, 110, 103, 0, 104, 116, 116, 112, 58, 47,
     *  47, 119, 119, 119, 46, 118, 101, 114, 115, 101, 98, 121, 118, 101,
     *  114, 115, 101, 113, 117, 114, 97, 110, 46, 99, 111, 109, 47, 84, 80
     * , 69, 49, 0, 0, 0, 10, 0, 0, 0, 65, 108, 32, 72, 117, 115, 97, 114,
     *  121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    */
//rootbundel must take from asset file
//try copy audio into asset then read it as bytes using rootbundle
/*    File newAudioInAsset = await file!.copy('images/new.wav');

    var bytesv = await rootBundle.load('images/new.wav');
    print('bbbbbbbbbbbbbbbbbbbbb $bytesv');
    print(bytesv.buffer.asFloat64List());
    //File('D:\flutter\tt\images\test.wav');

    //   var testBytes = await audioFile.readAsBytes();
    //   print('our bytes is : $testBytes');*/
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
  sendToPy(collectedURL) async {
    var serverBaseLink = 'https://3e96-156-194-125-117.eu.ngrok.io/?';
    var firbaseBaseLink =
        'https://firebasestorage.googleapis.com/v0/b/mlflutter-e5a7b.appspot.com/o/files';
    var response =
        await http.get(Uri.parse('${serverBaseLink}${collectedURL!.trim()}'));
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
    } else {
      isConnectionError = true;
      setState(() {});
    }
    print('url send :$collectedURL');
    print('url download send to python');
    print('response from python ${response.body}');
  }

  bool isPredictionCompleted = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
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
    assetsAudioPlayer.open(Audio.file(path), showNotification: true);
    currentAudioPlayed = assetsAudioPlayer.current.value;
    if (assetsAudioPlayer.currentPosition.value == PlayedAudioDuration) {
      print('reacheeeedddddddddddddddddddd');
    }
    PlayedAudioDuration = currentAudioPlayed!.audio.duration;
    PlayedAudioDurationMin = PlayedAudioDuration!.inMinutes;
    PlayedAudioDurationSec = PlayedAudioDuration!.inSeconds;
    print(currentAudioPlayed!.audio.duration);
    print('in play audio');
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
                child: Text(
                  'check your connection',
                  style: GoogleFonts.markaziText(
                      textStyle: TextStyle(
                          fontSize: 30,
                          color: currentMode == 'light'
                              ? lightTheme.LightThemeData.accentColor
                              : DarkTheme.whiteColor)),
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
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      : Container(),
                  !isPredictionCompleted
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
              await uploadFile();
              sendToPy(collectedURL);
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
            Text(bytes),
            //upload
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width:
                      path != '' ? MediaQuery.of(context).size.width * .15 : 0,
                ),
                widgets.stepContainer(
                    context, '1', AppLocalizations.of(context)!.upload),
                path != '' ? widgets.success(context, currentMode) : Container()
              ],
            ),
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
                : widgets.verticalLine(context, currentMode, lineHight: 50),

            // widgets.verticalLine(context, lineHight: 55),
            //step 2 predict or delete
            path != ''
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
                              resultNameContainer(name, currentMode)
                            ])
                          : Container()
                    ],
                  )
                : Container(),
            path != '' && isPredictionCompleted
                ? newPredictBtn(currentMode, currentLanguage, context)
                : Container(),
          ],
        ),
      ),
    );
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

  Widget newPredictBtn(
      String currentMode, String currentLang, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
          onPressed: () {
            isPredictionCompleted = false;
            path = '';
            isUploadingFBstart = false;
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
}
