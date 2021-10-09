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
  List<String> _transcriptsList = [];

  _saveListTrans(list) async {
    SharedPreferences prefstrans = await SharedPreferences.getInstance();

    prefstrans.setStringList("keyTrans", list);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Transcripts"),
      ),
      body: ListView.builder(
          itemCount: widget.value.length,
          itemBuilder: (context, index) {
            final item = widget.value[index];
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                setState(() {
                  widget.value.removeAt(index);
                  _saveListTrans(widget.value);
                });

                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Transcript deleted')));
              },
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red),
              child: ListTile(
                  title: Text(widget.value[index]),
                  trailing: Icon(Icons.access_time),
                  onTap: () => widget.value.removeAt(index)),
            );
            return Card(
                child: ListTile(
                    title: Text(widget.value[index].replaceAll("> ", "")),
                    trailing: Icon(Icons.access_time),
                    onTap: () => widget.value.removeAt(index)));
          }),
    );
  }
}
