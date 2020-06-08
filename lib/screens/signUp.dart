import 'package:app_chat/helper/helperfunctions.dart';
import 'package:app_chat/screens/chatRoom.dart';
import 'package:app_chat/screens/signIn.dart';
import 'package:app_chat/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/services/auth.dart';
import 'package:app_chat/services/database.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();

  signMeUp() async{
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      await authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,passwordTextEditingController.text).then((userID){
        //print("$userID");

        Map<String,String> userMap = {
          "email":emailTextEditingController.text,
          "name" : userNameTextEditingController.text,
          
        };

        HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

        databaseMethods.updateUserInfo(userMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading? CircularProgressIndicator(backgroundColor: Colors.red,):SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: formKey,
                    child: Column(
                    children: <Widget>[
                    TextFormField(
                    controller: userNameTextEditingController,
                    decoration: textFieldInputDecoration("username"),
                    validator: (val){
                      return val.isEmpty|| val.length<4 ? "Enter a valid username" : null;
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    controller: emailTextEditingController,
                    decoration: textFieldInputDecoration("email"),
                    
                    validator: (val){
                     return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter correct email";
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    controller: passwordTextEditingController,
                    decoration: textFieldInputDecoration("password"),
                    obscureText: true,
                    validator: (val){
                       return val.length<6 ? "Password must be atleast 6 characters long" : null;
                    },
                  ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20.0,),
                InkWell(
                  onTap: (){
                    signMeUp();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical:20.0),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: Text('Sign Up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),),
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
                    child: Text('Sign Up with Google',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),),
                  ),
                ),
                SizedBox(height: 30.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account?',style: TextStyle(color: Colors.white,fontSize: 14.0),),
                    SizedBox(width: 3.0,),
                    InkWell(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text('Sign In',
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
    );
  }
}