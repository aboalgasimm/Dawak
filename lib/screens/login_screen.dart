import 'package:dawak/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class LoginScreen extends StatelessWidget {
  
    LoginScreen({super.key});
    final Controller appController = Get.find();
   @override
  Widget build(BuildContext context) {
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(
        () => Scaffold(
         
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Image.asset('images/dawak.png', width: 200, height: 200),
        
                    const SizedBox(height: 50),
        
                    // اسم المستخدم
                    Row(
                      children: const [
                        Icon(Icons.person, color: Color.fromARGB(255, 32, 119, 90), size: 40),
                        SizedBox(width: 10),
                        Text('اسم المستخدم',
                            style:  TextStyle(fontSize: 18, fontFamily: 'Cairo')),
                      ],
                    ),
                    const SizedBox(height: 8),
        
                    TextField(
                          controller: appController.emailController,
                          onChanged: (_) => appController.enableSignIn(),
                          decoration: InputDecoration(
                            hintText: 'ادخل بريدك الالكتروني',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: appController.emailHasError.value
                                    ? Colors.red
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            errorText: appController.emailHasError.value
                            ? 'البريد الإلكتروني غير صالح'
                            : null,
                          ),
                        ),
        
                    const SizedBox(height: 24),
        
                    Row(
                      children: const [
                        Icon(Icons.lock,
                            color: Color.fromARGB(255, 32, 119, 90), size: 40),
                        SizedBox(width: 10),
                        Text('كلمة المرور',
                            style:  TextStyle(fontSize: 18, fontFamily: 'Cairo')),
                      ],   ),
        
                    const SizedBox(height: 8),
        
                    TextField(
                          controller: appController.passwordController,
                          obscureText: appController.obscurePassword.value,
                          onChanged: (_) => appController.enableSignIn(),
                          decoration: InputDecoration(
                            hintText: 'ادخل كلمة المرور',
                            suffixIcon: IconButton(
                              icon: Icon(
                                appController.obscurePassword.value
                                    ? Icons.visibility_off  : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: appController.hideAndShowPassword,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: appController.passwordHasError.value
                                    ? Colors.red
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            errorText: appController.passwordHasError.value
                            ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'
                            : null,
                          ),
                        ),
        
                    const SizedBox(height: 32),
        
                     SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: appController.isButtonClickable.value
                                ? appController.login
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:   Color.fromARGB(255, 32, 119, 90),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'تسجيل دخول',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
        
                    const SizedBox(height: 30),
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ليس لديك حساب؟ ',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Cairo',
                                decoration: TextDecoration.underline)),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Get.to(SignUpScreen());
                          },
                          child: const Text(
                            'سجل الآن',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Cairo',
                              color: Color.fromARGB(255, 32, 119, 90),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}