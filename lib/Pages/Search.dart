import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasechat/Helper/Constants.dart';
import 'package:firebasechat/Pages/Conversation.dart';
import 'package:firebasechat/Services/database.dart';
import 'package:firebasechat/Widgets/Header.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController _userName = TextEditingController();
  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(title: 'Search', subTitle: 'Find your friend here.'),
          SizedBox(
            height: size.height * .05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * .775,
                height: size.width * .145,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                  ),
                  controller: _userName,
                ),
              ),
              InkWell(
                onTap: () {
                  initiateSearch();
                },
                child: Container(
                  height: size.width * .135,
                  width: size.width * .135,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(16)),
                  child: Center(
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          searchTileListView()
        ],
      ),
    );
  }

  /// create chatRoom and send user to conversation screen
  createChatRoomAndStartConversation(String userName) {
    if (userName != Constants.myName) {
      print(userName);
      print("My name is ${Constants.myName}");
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Conversation(
                    chatRoomId: chatRoomId,
                  )));
    } else {
      print('You cannot send message to yourself');
    }
  }

  /// ListView
  Widget searchTileListView() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                username: searchSnapshot.docs[index].get("name"),
                email: searchSnapshot.docs[index].get("email"),
              );
            },
          )
        : Container();
  }

  /// ListTile
  Widget searchTile({String username, String email}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black)),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    email,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  minimumSize: Size(120, 40)),
              onPressed: () {
                createChatRoomAndStartConversation(username);
              },
              child: Text(
                'Message',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// getting user info into snapShot
  initiateSearch() {
    databaseMethods.getUserByUsername(_userName.text.trim()).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  /// ChatRoomId
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
