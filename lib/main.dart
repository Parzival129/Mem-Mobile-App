// Import important dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';

// Imoprt findParams function
import 'findParams.dart';

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
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Sparq Home Page'),
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

  @override
  void initState() {
    super.initState();
  }

  // Main functions for manipulating speech to text state
  void _init() async {
    print("starting init");
    _ready =
        await _speechToText.initialize(onError: _onError, onStatus: _onStatus);
    setState(() {});
    print("done");
  }

  void _start() async {
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
    _analyze(_lastWords);
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
          var rems = verbs[j] + ": " + params;
          _rem.add(rems);
          print(verbs[j] + ": " + params);
          print("REM: ");
          print(_rem);
        }
      }
    }

    return _rem;
  }

  void reminders() {
    setState(() {
      _reminders = [];
    });
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
                TextButton(
                    onPressed: _ready ? null : _init,
                    child: Text('Initialize')),
                TextButton(
                    onPressed: _ready && !_listening ? _start : null,
                    child: Text('Listen')),
                TextButton(
                    onPressed: _listening ? _stop : null, child: Text('Stop')),
                TextButton(
                    onPressed: _listening ? _cancel : null,
                    child: Text('Cancel')),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Divider(),
                  Text(
                    'Speech to text initialized: $_ready',
                  ),
                  Text(
                    'Status: $_lastStatus',
                  ),
                  Text(
                    'Error: $_lastError',
                  ),
                  Divider(),
                  Text(
                    'Words: $_lastWords',
                  ),
                  Divider(),
                  Text(
                    'Reminders: $_reminders',
                  ),
                ],
              ),
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
