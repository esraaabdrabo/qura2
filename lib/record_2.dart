/*import 'dart:io';

import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:tt/api/firebase_api.dart';
import 'package:http/http.dart' as http;
//import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class record extends StatefulWidget {
  const record({Key? key}) : super(key: key);

  @override
  State<record> createState() => _recordState();
}

class _recordState extends State<record> {
  WaveController? waveController;
  String? fileName;
  String? path;
  bool havePermission = false;
  UploadTask? task;
  String? collectedURL;
  //File? wavConverted=File('outputFile.wav');
  checkPermission() async {
    havePermission = await waveController!.hasPermission;
    if (havePermission != true)
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please enable the recording permission')));
  }

  createWavController() {
    waveController = WaveController();
    waveController!.encoder = Encoder.opus;
  }

  /////////////////////  done /////////////////////
  /*convertMp3ToWav() {
    String inputPath = 'test.mp3';
    String outputPath = 'test.wav';
    String command = 'ffmpeg -i $inputPath  $outputPath';

    var response =
     FFmpegKit.execute(command).then((session) async {
      session.isFFmpeg() ? print('session is ffmpeg') : print('not ffmpeg');
      //return code is for completed session
      //if failed or not started return => null
      final returnCode = await session.getReturnCode();
      print('return code $returnCode');
      ReturnCode.isSuccess(returnCode)
          ? print('is success ? yes')
          : print('is success ? no');
      ////////////////////////

      var createTime = session.getCreateTime();
      print('session created at : $createTime');
      var duration = await session.getDuration();
      print('the duration in millisecond is : $duration');
      var endTime = await session.getEndTime();
      print('session ended at : $endTime');

      var state = await session.getState();
      print('state : $state');
      print('command : ${session.getCommand()}');
    });
   
    response.onError((error, stackTrace) {
      print('error ${error}');
    });
  }*/

  @override
  void initState() {
    super.initState();
    //has permission start record
    //checkPermission();
    createWavController();
    //convertMp3ToWav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('test'),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                ////////file name /////////
                Padding(
                    padding: const EdgeInsets.all(80),
                    child: Text(
                        'my audio will be saved with next name :${fileName == null ? '  .......' : fileName}')),

                //icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //stop//
                    IconButton(
                      icon: Icon(
                        Icons.save,
                        size: 35,
                      ),
                      onPressed: () async {
                        path = await waveController!.stop();
                        print(path);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('recording stopped')));
                      },
                    ),
                    //start//
                    IconButton(
                      icon: Icon(
                        Icons.mic,
                        size: 35,
                      ),
                      onPressed: () async {
                        checkPermission();
                        await waveController!.record();
                        fileName = DateTime.now().toString();
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('recording start')));
                      },
                    ),
                    //pause//
                    IconButton(
                      icon: Icon(
                        Icons.pause,
                        size: 35,
                      ),
                      onPressed: () async {
                        await waveController!.pause();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('recording paused')));
                      },
                    ),
                    //delete//
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 35,
                      ),
                      onPressed: () async {
                        @override
                        //not working//
                        void dispose() {
                          waveController!.disposeFunc();
                          super.dispose();
                          setState(() {});
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('recording deleted')));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(19),
                  width: double.infinity,
                  color: Color.fromARGB(83, 224, 195, 195),
                  alignment: Alignment.centerRight,
                  child: AudioWaveforms(
                      size: Size(MediaQuery.of(context).size.width, 200.0),
                      waveStyle: WaveStyle(
                        showDurationLabel: true,
                      ),
                      waveController: waveController!),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await uploadFile();
                    },
                    child: Text('upload'))
              ],
            ),
          ),
        ));
  }

  Future uploadFile() async {
    final destination = 'records/$fileName';
    File file = File(path!);
    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');

    print('url download send to python');
    final uploadedAudioName = snapshot.ref.name;

    print('Download-Link: $urlDownload');

    var firbaseBaseLink =
        'https://firebasestorage.googleapis.com/v0/b/mlflutter-e5a7b.appspot.com/o/files';
    collectedURL =
        'downloadUrl=$urlDownload&firbaseBaseLink=$firbaseBaseLink&uploadedAudioName=$uploadedAudioName&fileExtension=';
  }
}
*/