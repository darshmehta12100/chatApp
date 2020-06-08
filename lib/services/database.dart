import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods{

  updateUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap);
  }

  getUserByUsername(String username)async{
    return await Firestore.instance.collection("users")
    .where("name",isEqualTo: username)
    .getDocuments();
  }

  getUserByEmail(String email)async{
    return await Firestore.instance.collection("users")
    .where("email",isEqualTo: email)
    .getDocuments();
  }

  createChatRoom(String chatRoomID, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
    .document(chatRoomID).setData(chatRoomMap)
    .catchError((e){
      print(e);
    });
  }

  addConversationMessages(String chatRoomID,messageMap){
    Firestore.instance.collection("ChatRoom")
    .document(chatRoomID)
    .collection("chats")
    .add(messageMap)
    .catchError((e){
      print(e.toString());
    });
  }
  
  getConversationMessages(String chatRoomID)async{
    return await Firestore.instance.collection("ChatRoom")
    .document(chatRoomID)
    .collection("chats")
    .orderBy("time")
    .snapshots();
  }

  getChatRooms(String userName)async{
    return await Firestore.instance.collection("ChatRoom")
    .where("users",arrayContains: userName)
    .snapshots();
  }
}