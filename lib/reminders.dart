import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class NextPage extends StatefulWidget {
  final List value;

  NextPage({Key key, this.value}) : super(key: key);

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {
  List<String> _remindersList = [];

  _saveList(list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList("key", list);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Reminders"),
      ),
      body: ListView.builder(
          itemCount: widget.value.length,
          itemBuilder: (context, index) {
            final item = widget.value[index].replaceAll("> ", "");
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                setState(() {
                  widget.value.removeAt(index);
                  _saveList(widget.value);
                });
              },
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red),
              child: ListTile(
                  title: Text(widget.value[index].replaceAll("> ", "")),
                  trailing: Icon(Icons.access_time),
                  onTap: () => widget.value.removeAt(index)),
            );
          }),
    );
  }
}
