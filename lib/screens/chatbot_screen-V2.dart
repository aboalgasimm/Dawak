import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotScreenV2 extends StatefulWidget {
  const ChatBotScreenV2({super.key});

  @override
  State<ChatBotScreenV2> createState() => _ChatBotScreenV2State();
}

class _ChatBotScreenV2State extends State<ChatBotScreenV2> {
  // Add your n8n webhook URL here
  static const String n8nWebhookUrl = 'https://abuelgasim.app.n8n.cloud/webhook/b3b06c3a-4636-464d-b281-ec904532c2e0/chat';
  
  final List<Message> messages = [
    Message(sender: "دواك", text: "اهلا انا مساعد دواك👋 كيف اقدر اساعدك اليوم؟", time: "9:24"),
  ];

  final TextEditingController _controller = TextEditingController();

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    final now = DateFormat('HH:mm').format(DateTime.now());
    setState(() {
      messages.add(Message(sender: "user", text: text, time: now));
    });
    _controller.clear();
    
    // Send to n8n and get response
    sendToN8n(text);
  }

  Future<void> sendToN8n(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse(n8nWebhookUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': userInput,
          'sender': 'user',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String botReply = responseData['reply'] ?? 'عذراً، لم أستطع فهم طلبك.';
        
        final now = DateFormat('HH:mm').format(DateTime.now());
        setState(() {
          messages.add(Message(sender: "دواك", text: botReply, time: now));
        });
     } else {
       print('Cannot Connect With N8N');
        // Fallback to local response if n8n fails
        setState(() {
          messages.add(generateLocalBotReply(userInput));
        });
     }
    } catch (e) {
      print('Cannot Connect With N8N Because Of This Error : ${e.toString()}');
      // Fallback to local response if there's an error
      // setState(() {
      //   messages.add(generateLocalBotReply(userInput));
      // });
    }
  }

  Message generateLocalBotReply(String userInput) {
    String reply;
    if (userInput.contains("مريض") || userInput.contains("تعبان")) {
      reply = "الف سلامة! اوصف لي شنو حاسس عشان اقدر اساعدك.";
    } else if (userInput.contains("مغص") || userInput.contains("معدة")) {
      reply = "يبدو ان لديك مشاكل في الجهاز الهضمي. أنصحك باستخدام دواء Buscopan.";
    } else if (userInput.contains("صداع")) {
      reply = "جرب تاخذ بنادول و ارتاح في مكان هادي.";
    } else if (userInput.contains("شكرا")) {
      reply = "العفو، أنا دائماً في خدمتك!";
    } else {
      reply = "ممكن توضح مشكلتك أكثر؟";
    }
    final now = DateFormat('HH:mm').format(DateTime.now());
    return Message(sender: "دواك", text: reply, time: now);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.teal),
            onPressed: () => Get.back(),
          ),
          title: Text(
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
                                backgroundImage:  AssetImage('images/dawak.png'),
                                radius: 16,
                              ),
                            if (msg.sender != "user")
                              const SizedBox(width: 6),
                            if (msg.sender == "user")
                              const Icon(Icons.account_circle_rounded,
                                  size: 32),
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
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14),
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
                      onSubmitted: sendToN8n,
                      decoration: InputDecoration(
                        hintText: "احكي لي مشكلتك",
                        hintStyle: TextStyle( fontFamily: 'Cairo' ),
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
        )    );
    
  }
}

class Message {
  final String sender;
  final String text;
  final String time;

  Message({required this.sender, required this.text, required this.time});
}