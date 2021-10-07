import 'package:flutter/material.dart';

class NextPage extends StatefulWidget {
  final List value;

  NextPage({Key key, this.value}) : super(key: key);

  @override
  _NextPageState createState() => new _NextPageState();
}

// class _NextPageState extends State<NextPage> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text("Reminders"),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(8),
//         children: widget.value.map((e) => Text(e)).toList(),
//       ),
//     );
//   }
// }

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Reminders"),
      ),
      body: ListView.builder(
          itemCount: widget.value.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                    title: Text(widget.value[index].replaceAll("> ", "")),
                    trailing: Icon(Icons.access_time)));
          }),
    );
  }
}

// ListView.builder(
//         itemCount: titles.length,
//         itemBuilder: (context, index) {
//           return Card(
//               child: ListTile(
//                   title: Text(titles[index]),
//                   subtitle: Text(subtitles[index]),
//                   leading: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                           "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
//                   trailing: Icon(icons[index])));
//         });


// children: widget.value.map((e) => Text(e)).toList(),