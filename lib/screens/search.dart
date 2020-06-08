import 'package:app_chat/helper/constants.dart';
import 'package:app_chat/helper/helperfunctions.dart';
import 'package:app_chat/screens/conversationScreen.dart';
import 'package:app_chat/services/database.dart';
import 'package:app_chat/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot.documents.length,
      itemBuilder: (BuildContext context,int index){
        return SearchTile(
          username: searchSnapshot.documents[index].data["name"],
          email: searchSnapshot.documents[index].data["email"],
        );
      }
    ):Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text)
    .then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({String userName}){
    //print(userName);
    //print(Constants.myName);

    if(userName != Constants.myName){
      //print(getChatRoomId(userName, Constants.myName));
      String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users = [userName,Constants.myName];
    Map<String,dynamic> chatRoomMap = {
      "users" : users,
      "chatroomid": chatRoomId
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId: chatRoomId,)));
    
    }
    else{
      print("You cannot send message to yourself");
    }
  }

  Widget SearchTile({String username,String email}){
    return Container(
      padding:EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(children: <Widget>[
            Text(username,style: TextStyle(fontSize: 14.0,color: Colors.white),),
            SizedBox(height: 5.0,),
            Text(email,style: TextStyle(fontSize: 12.0,color: Colors.white),),
          ],
        ),
        Container(
          height: 50.0,
          width: 100.0,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName: username);
            },
            child: Center(
              child: Text('Message',style: TextStyle(color: Colors.white,fontSize: 16.0,fontWeight: FontWeight.w600),)
              )
            ),
        )
      ],
    ),
  );
  }


  

  @override
  void initState() {
    // TODO: implement initState
    //getUserInfo();
    super.initState();
  }

  // getUserInfo() async{
  //   _myName = await HelperFunctions.getUserNameSharedPreference();
  //   setState(() {
      
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x20FFFFFF),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0,horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: TextField(
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                        hintText: 'Search by username',
                        hintStyle: TextStyle(color: Colors.white54,fontSize: 14.0),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                    SizedBox(width: 10.0,),
                    GestureDetector(
                      onTap: (){
                        initiateSearch();
                      },
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Image.asset("assets/search_white.png")
                      ),
                    )
                  ],
                ),
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}



getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}