import 'package:app_chat/helper/constants.dart';
import 'package:app_chat/helper/helperfunctions.dart';
import 'package:app_chat/screens/conversationScreen.dart';
import 'package:app_chat/screens/search.dart';
import 'package:app_chat/screens/signIn.dart';
import 'package:app_chat/services/auth.dart';
import 'package:app_chat/services/database.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  
  AuthMethods authMethods  = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,snapshot){
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context,int index){
            return ChatRoomTile(
              username: snapshot.data.documents[index].data["chatroomid"].toString().replaceAll("_", "")
            .replaceAll(Constants.myName, ""),
            chatRoomId: snapshot.data.documents[index].data["chatroomid"],
          );
          }
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getInfo();
    //databaseMethods.getChatRooms(Constants.myName);
    super.initState();
  }

  getInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
     
    });
     setState(() {
        
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png',height: 80.0,),
        centerTitle: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
            authMethods.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
          })
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen())); 
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {

  final String username;
  final String chatRoomId;

  ChatRoomTile({this.username,this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId: chatRoomId,)));
      },
          child: Container(
        
        padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20.0)

              ),
              child: Text("${username.substring(0,1).toUpperCase()}"),

            ),
            SizedBox(width: 10.0,),
            Text(username,style: TextStyle(fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
  }
}