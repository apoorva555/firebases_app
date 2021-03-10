import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    // Firebase.initializeApp();
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Linux APP"),
            backgroundColor: Colors.deepPurple[300],
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('date command')
                .snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.documents[index];
                  return ListTile(
                    title: Text(data['output']),
                  );
                },
              );
            },
          )),
    );
  }
}