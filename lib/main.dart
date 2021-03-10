import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

var message1 = "output ";
var output;
var cmd;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final databaseReference = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Linux App"),
          backgroundColor: Colors.deepPurple[300],
        ),
        body: mybody(),
      ),
    );
  }
}

class mybody extends StatefulWidget {
  @override
  _mybodyState createState() => _mybodyState();
}

class _mybodyState extends State<mybody> {
  web(cmd) async {
    print(cmd);
    var url = "http://192.168.43.111/cgi-bin/task2.py?x=${cmd}";
    var r = await http.get(url);
    print(r.body);
    setState(() {
      output = r.body;
    });

    createRecord();

    print('test123');
  }

  void Retrive() {
    setState(() {
      message1 = "Be patient we are fetching output";
    });
    databaseReference.collection("date command").snapshots().listen((result) {
      result.docs.forEach((result) {
        Future.delayed(const Duration(milliseconds: 4000), () {
          setState(() {
            message1 = result.data().toString();
          });
        });
      });
    });
  }

  void createRecord() async {
    await databaseReference.collection("date command").doc("result").set({
      'output': output,
    });
    Retrive();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (b) {
            cmd = b;
          },
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter host port you want to attach',
              suffixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(20)),
        ),
        RaisedButton(
          color: Colors.deepPurple[200],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          onPressed: () {
            web(cmd);
          },
          child: Text('Run'),
        ),
        Container(
          child: Text(message1),
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
          ),
        ),
      ],
    );
  }
}