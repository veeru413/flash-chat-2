import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_app2/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String? textMessage;
  final messageTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // _auth.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextField,
                      onChanged: (value) {
                        textMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (textMessage != null && loggedInUser != null) {
                        _firestore.collection('messages').add({
                          'text': textMessage,
                          'sender': loggedInUser!.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        messageTextField.clear(); // Ensure clearing after sending
                      }
                    },
                    child: const Text(
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

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data!.docs;
        List<MessageBubble> messageWidgets = [];

        for (var message in messages) {
          final messageData = message.data() as Map<String, dynamic>;
          final messageText = messageData['text'];
          final messageSender = messageData['sender'];
          final currentUser = loggedInUser!.email;

          final messageWidget = MessageBubble(
            mtext: messageText,
            mSender: messageSender,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String mtext;
  final String mSender;
  final bool isMe;

  const MessageBubble({required this.mtext, required this.mSender, required this.isMe});

  Color checkColor() {
    return isMe ? Colors.lightBlueAccent : Colors.white30;
  }

  BorderRadius borderRadiusCheck() {
    return isMe
        ? const BorderRadius.only(
        topLeft: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30))
        : const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30));
  }

  CrossAxisAlignment crossAxisCheck() {
    return isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: crossAxisCheck(),
        children: [
          Text(
            mSender,
            style: const TextStyle(fontSize: 12, color: Colors.white38),
          ),
          Material(
            elevation: 5,
            color: checkColor(),
            borderRadius: borderRadiusCheck(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                mtext,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
