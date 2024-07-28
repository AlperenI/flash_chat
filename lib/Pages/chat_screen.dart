// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chatt/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
final _firestore=FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
   static String id="chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    final _auth=FirebaseAuth.instance;
    
    TextEditingController messageTextController=TextEditingController();
     String? messageText;
    @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
    void getCurrentUser()async{try{
      final user=_auth.currentUser;
      if (user!=null) {
        loggedInUser=user;
        print(loggedInUser.email);
      }
      }catch(e){
        print(e);
      }
    }
 
 // void getMessages()async{
  //  final messages=await _firestore.collection("messages").get();
  //  for(var message in messages.docs){
  //    print(message.data());
 //   }
  //}
  void messagesStream()async{
   await for(var snapshot in _firestore.collection("messages").snapshots()){
    for(var message in snapshot.docs){
      print(message.data());
    }
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                      messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                    await  _firestore.collection("messages").add({
                        "text":messageText,
                        "sender":loggedInUser.email,
                        "time":FieldValue.serverTimestamp(),
                      });
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
  stream: _firestore.collection("messages").orderBy("time").snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      // Veriler yüklenirken bir yükleme göstergesi
      return Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      // Bir hata oluştuysa hata mesajını göster
      return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      // Eğer veri yoksa uygun bir mesaj göster
      return Center(child: Text('Mesaj bulunamadı'));
    }

    final messages = snapshot.data!.docs.reversed;
    List<Widget> messageWidgets = [];

    for (var message in messages) {
      final messageData = message.data() as Map<String, dynamic>;
      final messageText = messageData["text"] ?? '';
      final messageSender = messageData["sender"] ?? '';
      final currentUser=loggedInUser.email;

      final messageWidget = MessageBubble(
        sender: messageSender, 
        text: messageText,
        isMe: currentUser==messageSender,
        );
      messageWidgets.add(messageWidget);
    }

    return Expanded(
      child: ListView(
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        children: messageWidgets,
      ),
    );
  },
);
  }
}


class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  const MessageBubble({super.key, required this.sender, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(fontSize: 12,color: Colors.black54),),
          Material(
            borderRadius:isMe? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              ):BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            elevation: 5,
            color:isMe? Colors.white:Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color:isMe? Colors.black:Colors.white),),
                
            ),
          ),
        ],
      ),
    );
  }
}