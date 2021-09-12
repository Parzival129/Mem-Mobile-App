import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(MyApp());
}

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

  @override
  void initState() {
    super.initState();
  }

  void _init() async {
    _ready =
        await _speechToText.initialize(onError: _onError, onStatus: _onStatus);
    setState(() {});
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
// ! ///////////////////////////////////////////////////

  String _find(int i, List words) {
    for (var n = 1; n < 10000000; n++) {
      if (words[i + n] != "the" &&
          words[i + n] != "to" &&
          words[i + n] != "at" &&
          words[i + n] != "new" &&
          words[i + n] != "your" &&
          words[i + n] != "me") {
        //return words[i + n].toString();
        if (words[i + n + 1] == "at") {
          if (words[i + n + 3] == "PM" || words[i + n + 3] == "AM") {
            try {
              if (words[i + n + 4] == "on") {
                return words[i + n] +
                    " at " +
                    words[i + n + 2] +
                    " " +
                    words[i + n + 3] +
                    " on " +
                    words[i + n + 5] +
                    " " +
                    words[i + n + 6];
                // ! Error when not including month and day in params
              }
            } catch (rangeError) {
              return words[i + n] +
                  " at " +
                  words[i + n + 2] +
                  " " +
                  words[i + n + 3];
            }
            //return words[i + n] + " at " + words[i + n + 2] + " " + words[i + n + 3];
          }
        } else {
          return words[i + n];
        }
      }
    }
  }
//! //////////////////////////////////////////////////////////////

  void _analyze(String heard) async {
    // * Algorithm for detecting keywords and extracting important
    // * arguments from around the keywords
    print(heard);
    List<String> words = heard.split(" ");
    print(words);

    for (var i = 0; i < words.length; i++) {
      //print(words[i]);
      if (words[i].toLowerCase() == "meet") {
        print("found 'meet' keyword at: " + i.toString());
        var params = _find(i, words);
        print("meet: " + params);
      } else if (words[i].toLowerCase() == "take") {
        print("found 'take' keyword at: " + i.toString());
        var params = _find(i, words);
        print("take: " + params);
      } else if (words[i].toLowerCase() == "go") {
        print("found 'go' keyword at: " + i.toString());
        var params = _find(i, words);
        print("go to the: " + params);
      }
    }
  }

//! //////////////////////////////////////////////////////////////
  void _speechResult(SpeechRecognitionResult result) {
    setState(() {
      // * creation of the _lastWords variable
      // ? run detection & extraction algorithm
      _lastWords = result.recognizedWords;
    });
  }

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
