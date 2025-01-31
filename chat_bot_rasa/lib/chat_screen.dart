
import 'package:flutter/material.dart';
import 'rasa_server.dart';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final RasaService rasaService = RasaService(rasaServerUrl: 'http://172.26.43.40:5005');
  final TextEditingController _controller = TextEditingController();
  String _response = '';

  void _sendMessage() async {
    final message = _controller.text;
    _controller.clear();

    try {
      final response = await rasaService.sendMessage(message);
      setState(() {
        _response = response;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rasa Chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'En que te puedo ayudar',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
            SizedBox(height: 20),
            Text('Bot Response: $_response'),
          ],
        ),
      ),
    );
  }
}
