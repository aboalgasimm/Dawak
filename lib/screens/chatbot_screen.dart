import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// مفتاح Google Gemini (احصل عليه من MakerSuite)
const String geminiApiKey = 'AIzaSyBdCPYzTNc9UmY5EEZzq1k9zt4pL615wCM'; // 👈 استبدله بمفتاحك

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Message> messages = [
    Message(
      sender: "دواك",
      text: "مرحباً! أنا مساعد دواك 🤖. كيف أقدر أساعدك اليوم؟",
      time: DateFormat('HH:mm').format(DateTime.now()),
    ),
  ];

  final TextEditingController _controller = TextEditingController();

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final now = DateFormat('HH:mm').format(DateTime.now());
    setState(() {
      messages.add(Message(sender: "user", text: text, time: now));
    });
    _controller.clear();

    final reply = await fetchGeminiReply(text);

    final botTime = DateFormat('HH:mm').format(DateTime.now());
    setState(() {
      messages.add(Message(sender: "دواك", text: reply, time: botTime));
    });
  }

Future<String> fetchGeminiReply(String userInput) async {
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent?key=$geminiApiKey',
  );

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": "رد على هذا السؤال كمساعد صحي باللغة العربية: $userInput"}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final reply = data['candidates'][0]['content']['parts'][0]['text'];
    return reply.trim();
  } else {
    print("خطأ في Gemini: ${response.body}");
    return "حدث خطأ أثناء الاتصال بـ Gemini. حاول لاحقاً.";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'مساعد دواك',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.sender == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: msg.sender == "user"
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: msg.sender == "user"
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (msg.sender != "user")
                            const CircleAvatar(
                              backgroundImage: AssetImage('images/dawak.png'),
                              radius: 16,
                            ),
                          if (msg.sender != "user") const SizedBox(width: 6),
                          if (msg.sender == "user")
                            const Icon(Icons.account_circle_rounded, size: 32),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: msg.sender == "user"
                              ? Colors.green[100]
                              : Colors.teal[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg.text,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          msg.time,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: sendMessage,
                    decoration: InputDecoration(
                      hintText: "احكي لي مشكلتك",
                      hintStyle: const TextStyle(fontFamily: 'Cairo'),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => sendMessage(_controller.text),
                  child: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;
  final String time;

  Message({required this.sender, required this.text, required this.time});
}