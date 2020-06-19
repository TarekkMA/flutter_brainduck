import 'dart:async';
import 'dart:convert';

import 'package:bf_interpreter/interpreter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final codeController = TextEditingController(text: "");
  final outputController = TextEditingController(text: "");
  final inputController = TextEditingController(text: "");

  bool _isInputVisable = false;
  Completer _inputCompleter;

  Future displayCharacter(int char) async {
    outputController.text += String.fromCharCode(char);
  }

  Future<int> getInputCharacter() async {
    _inputCompleter = Completer();
    setState(() {
      _isInputVisable = true;
    });
    await _inputCompleter.future;
    int char = AsciiCodec().encode(inputController.text)[0];
    inputController.clear();
    return char;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Brainfuck Interpreter"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: codeController,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code',
                  ),
                  maxLines: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () async {
                      outputController.clear();
                      await Interpreter(
                        code: codeController.text,
                        putChar: displayCharacter,
                        getChar: getInputCharacter,
                      ).interpret();
                    },
                    child: Text(
                      "RUN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Divider(),
              Visibility(
                visible: _isInputVisable,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: inputController,
                          maxLength: 1,
                          maxLines: 1,
                          decoration: InputDecoration(hintText: "Input"),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: () {
                          if (inputController.text.isNotEmpty) {
                            _inputCompleter.complete();
                          }
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: TextField(
                  controller: outputController,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Output',
                  ),
                  maxLines: null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
