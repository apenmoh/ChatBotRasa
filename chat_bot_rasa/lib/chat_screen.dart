import 'package:flutter_tts/flutter_tts.dart';  
import 'package:speech_to_text/speech_to_text.dart' as stt;
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

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTTS();
    _initSpeechToText();
  }

  void _initTTS() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  void _initSpeechToText() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (errorNotification) => print('onError: $errorNotification'),
    );

    if (!available) {
      print("El usuario ha denegado el uso del reconocimiento de voz.");
    }
  }

  void _speakResponse(String response) async {
    await Future.delayed(Duration(milliseconds: 500));
    await _flutterTts.speak(response);
  }

  void _toggleListening() async {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(
          localeId: "es_ES",
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
        setState(() {
          _isListening = true;
        });
      }
    }
  }

  void _sendMessage() async {
    final message = _controller.text;
    _controller.clear();
    try {
      final response = await rasaService.sendMessage(message);
      setState(() {
        _response = response;
      });

      _speakResponse(response);
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Asistente de Cocina '),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://cdn.pixabay.com/photo/2016/11/29/04/49/blueberries-1867398_640.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Pregunta sobre recetas o ingredientes:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      if (_response.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Respuesta: $_response',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Escribe tu pregunta...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: _isListening ? Colors.redAccent : Colors.green,
                  child: IconButton(
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: Colors.white),
                    onPressed: _toggleListening,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
