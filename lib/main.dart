// Import important dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

// Import findParams function
import 'findParams.dart';

// Import reminders page
import 'reminders.dart';

// Import transcripts page
import 'transcripts.dart';

// Main function for running app
void main() {
  runApp(MyApp());
}

// API usage: print(await http.read(Uri.parse('https://tc32fzdoz9.execute-api.us-east-2.amazonaws.com/Prod/hello/')));

// MyApp widget that directs to homepage
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPARQ',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
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
  String _lastWords = "you haven't said anything yet";
  int _minimumWordsForTrans = 10;
  String _lastStatus = '';
  String _lastError = '';
  List _reminders = [];
  String _transcript = "";
  bool _isLoading = false;
  List<String> _remindersList = [];
  List<String> _rems = [];

  List<String> _transcriptsList = [];
  List<String> _trans = [];
  List<String> _conversationList = [];

  String _convName = "";

  String talker = "";
  String text = "";

  void _setText() {
    setState(() {
      talker = talker + " ";
      text = talker;
      print("Talker set to: " + talker);
    });
  }

  _saveList(list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList("key", list);

    return true;
  }

  _saveListTrans(list) async {
    SharedPreferences prefstrans = await SharedPreferences.getInstance();

    prefstrans.setStringList("keyTrans", list);

    return true;
  }

  _getSavedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("key") != null)
      _remindersList = prefs.getStringList("key");
    setState(() {});
  }

  _getSavedListTrans() async {
    SharedPreferences prefstrans = await SharedPreferences.getInstance();
    if (prefstrans.getStringList("keyTrans") != null)
      _transcriptsList = prefstrans.getStringList("keyTrans");
    setState(() {});
  }

  _saveListConv(list) async {
    SharedPreferences prefsconv = await SharedPreferences.getInstance();

    prefsconv.setStringList("keyConv", list);

    return true;
  }

  _getSavedConv() async {
    SharedPreferences prefsconv = await SharedPreferences.getInstance();
    if (prefsconv.getStringList("keyConv") != null)
      _conversationList = prefsconv.getStringList("keyConv");
    setState(() {});
  }

  _eraseAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefstrans = await SharedPreferences.getInstance();
    SharedPreferences prefConv = await SharedPreferences.getInstance();

    prefs.clear();
    prefstrans.clear();
    prefConv.clear();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _getSavedList();
    _getSavedListTrans();
    _getSavedConv();
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
    _remindersList.addAll(_reminders.cast<String>());

    _transcript = _lastWords;

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    _convName = date.toString();
    // 2016-01-25
    _conversationList.add(_convName);

    _saveListConv(_conversationList);

    _transcriptsList.add(_transcript);
    _saveList(_remindersList);
    if (_lastWords != "" &&
        _lastWords.split(" ").length >= _minimumWordsForTrans) {
      _saveListTrans(_transcriptsList);
    }

    print(_remindersList.toString());
    print(_transcriptsList.toString());
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
      // words.length changes O(n)?
      for (var j = 0; j < verbs.length; j++) {
        // verbs.length doesn't change
        if (words[i].toLowerCase() == verbs[j]) {
          // add more logic for detecting if something is a scheduling statment
          if (verbs[j].toLowerCase() == "remember") {
            print("found " + verbs[j] + " keyword at: " + i.toString());
            var params = findParams(i, words);
            try {
              if (words[i - 1].toLowerCase() == "don't" ||
                  words[i - 2].toLowerCase() == "don't" ||
                  words[i - 3].toLowerCase() == "don't" ||
                  words[i - 4].toLowerCase() == "don't") {
                if (params != "ERROR_OCCURED") {
                  var rems =
                      talker + "> " + "Don't " + verbs[j] + ": " + params;
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
          //var params = findParams(i, words);

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
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent[100],
              ),
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
                style: ElevatedButton.styleFrom(primary: Colors.red)),
            // changes in text
            // are shown here
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  _lastWords,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new FloatingActionButton(
                    heroTag: "micStart",
                    backgroundColor: !_listening ? Colors.red : Colors.purple,
                    onPressed: !_listening ? _start : null,
                    child: Icon(_listening ? Icons.mic : Icons.mic_none)),
                new FloatingActionButton(
                    heroTag: "micStop",
                    backgroundColor: Colors.red,
                    onPressed: _listening ? _stop : null,
                    child: Icon(Icons.stop)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: new Text("Reminders"),
                  onPressed: () {
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new NextPage(value: _remindersList),
                    );
                    Navigator.of(context).push(route);
                  },
                ),
                ElevatedButton(
                  child: new Text("Transcripts"),
                  onPressed: () {
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new NextPageTrans(value: _transcriptsList),
                    );
                    Navigator.of(context).push(route);
                  },
                )
              ],
            ),
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
