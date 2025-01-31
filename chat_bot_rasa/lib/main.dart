import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ChatBot',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplicaicon de ChatBot"),
      ),  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Flutter ChatBot!'),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement functionality for interacting with the chatbot
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  ChatScreen()));
                print('Chatbot interaction initiated');
              },
              child: Text('Ir al chatbot'),
            ),
          ],
        ),
      ),
    );
  }
}


