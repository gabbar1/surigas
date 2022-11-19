import 'package:flutter/material.dart';

class agent extends StatefulWidget {
  const agent({Key? key, this.name}) : super(key: key);
  final String? name;
  @override
  State<agent> createState() => _agentState();
}

class _agentState extends State<agent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(widget.name.toString()),
      ),
    );
  }
}
