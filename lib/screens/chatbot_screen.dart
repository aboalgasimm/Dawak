import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Message> messages = [
    Message(sender: "دواك", text: "اهلا انا مساعد دواك👋 كيف اقدر اساعدك اليوم؟", time: "9:24"),
  ];

  final TextEditingController _controller = TextEditingController();

  void sendMessage(String text) {
    final now = DateFormat('HH:mm').format(DateTime.now());
    setState(() {
      messages.add(Message(sender: "user", text: text, time: now));
      messages.add(generateBotReply(text));
    });
    _controller.clear();
  }

  Message generateBotReply(String userInput) {
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
                      onSubmitted: sendMessage,
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