import 'package:flutter/material.dart';
import 'package:tt/widegets/audioCard.dart';

class userRecords extends StatefulWidget {
  @override
  State<userRecords> createState() => _userRecordsState();
}

class _userRecordsState extends State<userRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return index % 2 == 0 ? audioCard() : audioCard(true);
          }),
    );
  }
}
