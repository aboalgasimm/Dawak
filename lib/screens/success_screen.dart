import 'package:dawak/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class SuccessScreen extends StatelessWidget {
   SuccessScreen({super.key});
   final Controller appController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                // الشعار والنصوص
                    CircleAvatar(
                      backgroundColor: Colors.green[200],
                      radius: 120,
                      backgroundImage: AssetImage('images/dawak.png'), // تأكد من وجود الصورة في مجلد assets
                    ),
                 
                    SizedBox(height: 40),
            
                   Text(
                        'أهلاً ${appController.username} 👋, تم انشاء حساب بنجاح 🎉',
                        style: TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                        textAlign: TextAlign.center,
                      ),
                             
                // الزر
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: ElevatedButton(
                    onPressed: () {
                        Get.offAll(LoginScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 32, 119, 90),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'انتقل لصفحة تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}