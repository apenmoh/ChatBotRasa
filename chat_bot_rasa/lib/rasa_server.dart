import 'dart:convert';
import 'package:http/http.dart' as http;

class RasaService {
  final String rasaServerUrl;

  RasaService({required this.rasaServerUrl});

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('$rasaServerUrl/webhooks/rest/webhook'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sender': 'user',
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.isNotEmpty ? data[0]['text'] : 'No response from bot';
    } else {
      throw Exception('Failed to load response from Rasa');
    }
  }
}