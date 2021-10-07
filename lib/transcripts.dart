import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class NextPageTrans extends StatefulWidget {
  final List value;

  NextPageTrans({Key key, this.value}) : super(key: key);

  @override
  _NextPageStateTrans createState() => new _NextPageStateTrans();
}

class _NextPageStateTrans extends State<NextPageTrans> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Transcripts"),
      ),
      body: ListView.builder(
          itemCount: widget.value.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                    title: Text(widget.value[index]),
                    trailing: Icon(Icons.description),
                    onTap: () => widget.value.removeAt(index)));
          }),
    );
  }
}
