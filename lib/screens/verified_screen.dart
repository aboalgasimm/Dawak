import 'package:dawak/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';


class VerifiedScreen extends StatelessWidget {
   VerifiedScreen({super.key});
   final Controller appController = Get.find();

  @override
  Widget build(BuildContext context) {
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF00897B),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شعار التطبيق داخل دائرة
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 100,
                  child: Image.asset(
                    'images/dawak.png', // تأكد من وجود الشعار داخل مجلد assets
                  ),  ),

              
              const SizedBox(height: 60),
              // رسالة التحقق
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '✅',
                    style: TextStyle(fontSize: 24, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تم التحقق من رقم الهاتف',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Cairo'
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              // زر الرجوع للصفحة تسجيل حساب
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  appController.enableSignUp();
                  Get.offAll(SignUpScreen());
                },
                child: Text(
                  'الرجوع لصفحة تسجيل حساب',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}