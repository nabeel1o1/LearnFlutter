import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutteroid_app/chat_app/widgets/chat_messages.dart';
import 'package:flutteroid_app/chat_app/widgets/new_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();

    _setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text('Welcome ${snapshot.data!['username']}'),
                actions: [
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
              body: const Column(
                children: [
                  Expanded(
                    child: ChatMessages(),
                  ),
                  NewMessages()
                ],
              ));
        }
      },
    );
  }
}
