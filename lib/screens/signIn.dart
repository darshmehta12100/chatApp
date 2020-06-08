import 'package:app_chat/helper/helperfunctions.dart';
import 'package:app_chat/screens/chatRoom.dart';
import 'package:app_chat/screens/signUp.dart';
import 'package:app_chat/services/database.dart';
import 'package:app_chat/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  signIn(){
    if(formKey.currentState.validate()){

      databaseMethods.getUserByEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
        //print(snapshotUserInfo.documents[0]);
      });

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        if(val!=null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });

      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Form(
                key: formKey,
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: emailTextEditingController,
                    decoration: textFieldInputDecoration("email"),
                    validator: (val){
                     return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter correct email";
                    }
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    controller: passwordTextEditingController,
                    decoration: textFieldInputDecoration("password"),
                    obscureText: true,
                    validator: (val){
                       return val.length<6 ? "Password must be atleast 6 characters long" : null;
                    }
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.5),
                    child: InkWell(
                      onTap: (){print("Forgot Password");},
                      child: Text('Forgot Password?',style: TextStyle(fontSize: 16.0,color: Colors.white,fontWeight: FontWeight.w500,decoration: TextDecoration.underline))
                     )
                    ),
                  SizedBox(height: 10.0,),
                  InkWell(
                    onTap: (){
                      signIn();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical:20.0),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Text('Sign In',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical:20.0),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        color: Colors.redAccent[200],
                        borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Text('Sign In with Google',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Don\'t have an account?',style: TextStyle(color: Colors.white,fontSize: 14.0),),
                      SizedBox(width: 3.0,),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                        },
                        child: Text('Register Now',
                        style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.w800,decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  )
                ],
            ),
              ),
          ),
        ),
      ),
    );
  }
}