import 'dart:async';
import 'package:dawak/screens/verified_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int minutes = 15;
  int seconds = 0;
  late Timer _timer;
  var numberController = TextEditingController();
  bool isLocked = true;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutes == 0 && seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          if (seconds == 0) {
            minutes--;
            seconds = 59;
          } else {
            seconds--;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get timeFormatted =>
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(

        body: Column(
          children: [
            const SizedBox(height: 60),
            const Spacer(),
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 100),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00897B),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(160),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'تم ارسال رمز التحقق',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Cairo'
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        timeFormatted,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo'
                        ),  ),

                      const SizedBox(height: 30),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.teal[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: numberController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                              setState(() {
                                numberController.text = value;
                                if(numberController.text.length >= 6) {
                                  isLocked = false;
                                } else {
                                  isLocked = true;
                                }
                              });
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'الرجاء ادخال رمز التحقق',
                            hintStyle: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                        ),  ),

                      SizedBox(height: 25),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),  ),

                        onPressed: () {
                          setState(() {
                            minutes = 15;
                            seconds = 0;
                            _timer.cancel();
                            startCountdown();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'اعادة ارسال الرمز',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                          )
                        ),
                        onPressed: (isLocked) ? null : () {
                          Get.to(VerifiedScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:  10),
                          child: Text('تحقق', style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold
                              ),),
                        )  ),

                        SizedBox(height: 33),

                    ],
                  ),  ),

                Positioned(
                  top: -100,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 92,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 90,
                            child: Image.asset(
                              'images/dawak.png',
                              height: 180,
                            ),
                          
                        ),
                      ),
                      const SizedBox(height: 8),
                    
                    ],
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