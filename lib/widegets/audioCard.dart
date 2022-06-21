import 'dart:math' as math;

import 'package:flutter/material.dart';
//import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:tt/widegets/widgets.dart';

class audioCard extends StatefulWidget {
  bool needRightCard;
//if need right card = true => return container else will
//return left
  audioCard([this.needRightCard = false]);
  @override
  State<audioCard> createState() => _audioCardState();
}

class _audioCardState extends State<audioCard> {
  bool playAudio = false;
  enableMiniMusic() {
    playAudio ? playAudio = false : playAudio = true;
    setState(() {});
  }

  Widget nameContainer({bool needTransform = false}) {
    return Container(
        alignment:
            AlignmentGeometry.lerp(Alignment.center, Alignment.center, 1),
        height: MediaQuery.of(context).size.width * .15,
        // color: Color.fromARGB(218, 87, 151, 47),
        width: MediaQuery.of(context).size.width * .4,
        child: needTransform
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Text(
                  ' الشيخ الحصري',
                  //textDirection: TextDirection.rtl,
                ),
              )
            : Text('الشيخ الحصري'));
  }

  Widget playbtnContainer({bool needTransform = false}) {
    return Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 251, 251, 229),
            border: Border.all(color: Color.fromARGB(193, 245, 242, 242)),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: IconButton(
          icon: needTransform
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(playAudio ? Icons.pause : Icons.play_arrow))
              : Icon(playAudio ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            enableMiniMusic();
          },
        ));
  }

  Widget musicContainer() {
    return playAudio
        ? SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.width * .1,
            child: widgets.musicLine(context, ''))
        : widgets.silenceLine(context, '');
    //line when not play
  }

  @override
  Widget build(BuildContext context) {
    return widget.needRightCard
        ?
        //english container left to right

        //in right
        Container(
            //to have transparent container which will
            // allow the play icon be outside the background container
            width: MediaQuery.of(context).size.width,
            //  height: MediaQuery.of(context).size.width * .3,
            //   color: Color.fromARGB(193, 217, 91, 91),
            //to put content on the container which have the background image
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    //background image
                    //parent
                    widgets.predictionBackgroundContainer(context),
                    Column(
                      children: [
                        //shekh name
                        //upper space under the name background
                        //explanation => the parent container have width = .8
                        //will make a row that have 2 containers and equal in  width =.4
                        //to make the name in center of design
                        Row(
                          children: [
                            //just space on left
                            Container(
                              color: Color.fromARGB(218, 151, 94, 47),
                              width: MediaQuery.of(context).size.width * .4,
                            ),
                            //name
                            nameContainer(),
                          ],
                        ),

                        // music and play icon
                        Row(
                          children: [
                            //space before music
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .04,
                            ),
                            //play icon
                            playbtnContainer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .1,
                            ),
                            //music
                            musicContainer()
                          ],
                        ),
                      ],
                    ),
                    //background
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                )
              ],
            ),
          )
        :
        //in left
        Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Container(
              //to have transparent container which will
              // allow the play icon be outside the background container
              width: MediaQuery.of(context).size.width,
              //to put content on the container which have the background image
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      //background image
                      //parent
                      widgets.predictionBackgroundContainer(context),
                      Column(
                        children: [
                          //shekh name
                          //upper space under the name background
                          //explanation => the parent container have width = .8
                          //will make a row that have 2 containers and equal in  width =.4
                          //to make the name in center of design
                          Row(
                            children: [
                              //just space on left
                              Container(
                                color: Color.fromARGB(218, 151, 94, 47),
                                width: MediaQuery.of(context).size.width * .4,
                              ),
                              //name
                              nameContainer(needTransform: true),
                            ],
                          ),

                          // music and play icon
                          Row(
                            children: [
                              //space before music
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .04,
                              ),
                              //play icon
                              playbtnContainer(needTransform: true),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .1,
                              ),
                              //music
                              musicContainer()
                            ],
                          ),
                        ],
                      ),
                      //background
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
