import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechat/Helper/Constants.dart';
import 'package:firebasechat/Helper/helperFunctions.dart';
import 'package:firebasechat/Pages/Conversation.dart';
import 'package:firebasechat/Pages/Search.dart';
import 'package:firebasechat/Services/Auth.dart';
import 'package:firebasechat/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user;
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapShot) {
        return snapShot.hasData
            ? ListView.builder(
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  return chatRoomTile(
                      snapShot.data.docs[index]
                          .data()["chatRoomId"]
                          .toString()
                          .replaceAll("_", "")
                          .toString()
                          .replaceAll(Constants.myName, ""),
                      snapShot.data.docs[index].data()["chatRoomId"]);
                },
              )
            : Container();
      },
    );
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRoom(Constants.myName).then((val) {
      chatRoomStream = val;
    });
    var emaill = await HelperFunctions.getUserEmailSharedPreference();
    print(emaill.toString());
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await auth.signOut();
              })
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }

  Widget chatRoomTile(String username, chatRoomId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Conversation(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                child: CircleAvatar(
                  child: Text(
                    '${username[0].toUpperCase()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.purpleAccent[400],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(username)
            ],
          ),
        ),
      ),
    );
  }
}
