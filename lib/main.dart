// Import important dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// Import findParams function
import 'findParams.dart';

// Import reminders page
import 'reminders.dart';

// Main function for running app
void main() {
  runApp(MyApp());
}

// MyApp widget that directs to homepage
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPARQ',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(title: "SPARQ"),
    );
  }
}

class NewApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPARQ',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(title: "SPARQ"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _ready = false;
  bool _listening = false;
  String _lastWords = '';
  String _lastStatus = '';
  String _lastError = '';
  List _reminders = [];
  bool _isLoading = false;
  List _remindersList = [];
  List<String> _rems = [];

  String talker = "";
  String text = "";

  void _setText() {
    setState(() {
      text = talker;
      print("Talker set to: " + talker);
    });
  }

  _saveList(list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList("key", list);

    return true;
  }

  _getSavedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("key") != null) _rems = prefs.getStringList("key");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _getSavedList();

    setState(() {
      _isLoading = false;
    });
  }

  // Main functions for manipulating speech to text state

  void _start() async {
    print("starting init");
    _ready =
        await _speechToText.initialize(onError: _onError, onStatus: _onStatus);
    setState(() {});
    print("done");
    print("starting");
    await _speechToText.listen(onResult: _speechResult);
    _listening = true;
    setState(() {});
  }

  void _stop() async {
    print("stopping");
    _speechToText.stop();
    _listening = false;
    setState(() {});
    // ? calling the primary analyzation algorithm
    _reminders = await _analyze(_lastWords);
    _rems = (_remindersList + _reminders).cast<String>();
    _saveList(_rems);
    setState(() {});
  }

  void _cancel() async {
    _speechToText.cancel();
    _listening = false;
    setState(() {});
  }

  // analyzation algorithm to run on all heard text
  Future<List> _analyze(String heard) async {
    // * Algorithm for detecting keywords and extracting important
    // * arguments from around the keywords
    List _rem = [];
    List<String> words = heard.split(" ");
    print(words);

/////////////////////////
    String responseText;
    responseText = await rootBundle.loadString('assets/verbs.txt');
    //print(responseText);
    List verbs = responseText.split("\n");
    //print(verbs);
    print("# of Verbs incorporated: " + verbs.length.toString());

////////////////////////
    for (var i = 0; i < words.length; i++) {
      for (var j = 0; j < verbs.length; j++) {
        if (words[i].toLowerCase() == verbs[j]) {
          print("found " + verbs[j] + " keyword at: " + i.toString());
          var params = findParams(i, words);
          try {
            if (words[i - 1].toLowerCase() == "don't" ||
                words[i - 2].toLowerCase() == "don't" ||
                words[i - 3].toLowerCase() == "don't" ||
                words[i - 4].toLowerCase() == "don't") {
              if (params != "ERROR_OCCURED") {
                var rems = talker + "> " + "Don't " + verbs[j] + ": " + params;
                _rem.add(rems);
                print(talker + "> " + "Don't " + verbs[j] + ": " + params);
                print("REM: ");
                print(_rem);
              }
            } else {
              if (params != "ERROR_OCCURED") {
                var rems = talker + "> " + verbs[j] + ": " + params;
                _rem.add(rems);
                print(talker + "> " + verbs[j] + ": " + params);
                print("REM: ");
                print(_rem);
              }
            }
          } catch (rangeError) {
            if (params != "ERROR_OCCURED") {
              var rems = talker + "> " + verbs[j] + ": " + params;
              _rem.add(rems);
              print(talker + "> " + verbs[j] + ": " + params);
              print("REM: ");
              print(_rem);
            }
          }
        }
      }
    }
    return _rem;
  }

  void _speechResult(SpeechRecognitionResult result) {
    setState(() {
      // * creation of the _lastWords variable
      // ? run detection & extraction algorithm
      _lastWords = result.recognizedWords;
    });
  }

  // main homepage UI construction
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: _start, child: Text('Listen')),
                TextButton(
                    onPressed: _listening ? _stop : null, child: Text('Stop')),
                TextButton(
                    onPressed: _listening ? _cancel : null,
                    child: Text('Cancel')),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                decoration:
                    InputDecoration(labelText: 'Who are you talking to?'),
                onChanged: (value) => talker = value,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: _setText,
              child: Text('Submit'),
            ),
            // changes in text
            // are shown here
            Expanded(
              child: Column(
                children: [
                  Divider(),
                  Text(
                    'Words: $_lastWords',
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: new Text("Reminders"),
              onPressed: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new NextPage(value: _rems),
                );
                Navigator.of(context).push(route);
              },
            )
          ],
        ),
      ),
    );
  }

  void _onStatus(String status) {
    _lastStatus = status;
  }

  void _onError(SpeechRecognitionError errorNotification) {
    _lastError = errorNotification.errorMsg;
  }
}
