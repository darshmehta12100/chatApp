import 'package:app_chat/helper/helperfunctions.dart';
import 'package:app_chat/screens/chatRoom.dart';
import 'package:app_chat/screens/search.dart';
import 'package:app_chat/screens/signIn.dart';
import 'package:app_chat/screens/signUp.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isUserLogin;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((val){
      setState(() {
        isUserLogin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueAccent[100]
      ),
      debugShowCheckedModeBanner: false,
      home: isUserLogin != null ? isUserLogin ? ChatRoom() : SignIn() : SignIn(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}

