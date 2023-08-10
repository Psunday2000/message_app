// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MessagesEverydayApp());
}

class MessagesEverydayApp extends StatelessWidget {
  const MessagesEverydayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messages Everyday',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Raleway',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MessagesScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/log.png',
              height: 100, // Adjust the size here
            ),
            const SizedBox(height: 16),
            const Text(
              'Messages Everyday',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<String> messages = [];
  String selectedMessage = ''; // Add this variable

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  final logger = Logger();

  Future<void> loadMessages() async {
    final String data = await rootBundle.loadString('assets/messages.json');
    logger.d("Loaded JSON Data: $data");

    final Map<String, dynamic> jsonData = json.decode(data);
    final List<String> messageList = List<String>.from(jsonData['messages']);
    setState(() {
      messages = messageList;
    });
  }

  void copyToClipboard(String message) {
    Clipboard.setData(ClipboardData(text: message));
    Fluttertoast.showToast(
      msg: 'Message copied to clipboard',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages Everyday'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedMessage, // Display the selected message
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (messages.isNotEmpty) {
                  final randomIndex = Random().nextInt(messages.length);
                  setState(() {
                    selectedMessage =
                        messages[randomIndex]; // Update selected message
                  });
                }
              },
              child: const Text('Generate Message'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedMessage.isNotEmpty) {
                  // Check if message is not empty
                  copyToClipboard(selectedMessage);
                }
              },
              child: const Text('Copy Message'),
            ),
          ],
        ),
      ),
    );
  }
}
