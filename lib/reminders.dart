import 'package:flutter/material.dart';

class NextPage extends StatefulWidget {
  final List value;

  NextPage({Key key, this.value}) : super(key: key);

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Reminders"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: widget.value.map((e) => Text(e)).toList(),
      ),
    );
  }
}
