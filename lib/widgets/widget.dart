import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    backgroundColor: Colors.blue[500],
    title: Image.asset('assets/logo.png',height: 80.0,),
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.w300),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),
  );
}