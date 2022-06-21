import 'package:flutter/material.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';

class musicLine extends StatefulWidget {
  @override
  State<musicLine> createState() => _musicLineState();
}

class _musicLineState extends State<musicLine> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return MiniMusicVisualizer(
            color: Color.fromARGB(255, 236, 226, 225),
            width: 4,
            height: 15,
          );
        },
        itemCount: 10,
      ),
    );
  }
}
