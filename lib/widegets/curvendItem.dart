import 'package:flutter/material.dart';

class curveditem extends StatefulWidget {
  IconData iconName;
  curveditem({required this.iconName});
  @override
  State<curveditem> createState() => _curveditemState();
}

class _curveditemState extends State<curveditem> {
  @override
  Widget build(BuildContext context) {
       return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(widget.iconName),
          );

  }
}