import 'package:dawak/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
   final Controller appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  'images/dawak.png', // Ensure this path is correct and the image exists
                  width: 300, // Adjust size as needed
                  height: 300, // Adjust size as needed
                ),
                const SizedBox(height: 10),
                const Text(
                  'حبابك في تطبيق \nدواك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    
                    color: Colors.black87,
                    fontFamily: 'Cairo', // Make sure to add Cairo font to pubspec.yaml
                  ),
                ),
                const SizedBox(height: 100), // Spacing before the button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      appController.email = '';
                      appController.password = '';
                      appController.emailController.clear();
                      appController.passwordController.clear();
                      Get.offAll(LoginScreen());  // this removes all previous screens and navigates to a new one

                      // Navigator.pushAndRemoveUntil(context,
                      // MaterialPageRoute(builder: (context) => LoginScreen()), 
                      // (route) => false  // this removes all previous routes
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'ابدأ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo', // Make sure to add Cairo font to pubspec.yaml
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 20), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}