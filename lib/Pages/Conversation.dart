import 'package:firebasechat/Helper/Constants.dart';
import 'package:firebasechat/Services/database.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;

  const Conversation({Key key, this.chatRoomId}) : super(key: key);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController _myMessage = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatMessageStream;

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      chatMessageStream = val;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      child: Stack(
        children: [
          /// displaying chat messages
          chatMessagesList(),

          /// Message text form field  and send button
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: size.width * .775,
                  height: size.width * .145,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Message",
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurpleAccent)),
                    ),
                    controller: _myMessage,
                  ),
                ),
                InkWell(
                  onTap: () {
                    sendMessage();
                    _myMessage.clear();
                  },
                  child: Container(
                    height: size.width * .135,
                    width: size.width * .135,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget chatMessagesList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapShot) {
        return snapShot.hasData
            ? ListView.builder(
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  return messageTile(
                      snapShot.data.docs[index].data()["message"],
                      snapShot.data.docs[index].data()["sendBy"] ==
                          Constants.myName);
                },
              )
            : Container();
      },
    );
  }

  Widget messageTile(String message, bool isSendByMe) {
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 12, right: isSendByMe ? 12 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .7),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe
                  ? [
                      const Color(0xff007ef4),
                      const Color(0xff2a75bc),
                    ]
                  : [
                      const Color(0xFF393E44),
                      const Color(0xFF3C3E40),
                    ]),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  sendMessage() {
    if (_myMessage.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": _myMessage.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }
}
