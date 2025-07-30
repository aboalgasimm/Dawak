// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class SignUpScreen extends StatelessWidget {
  
   SignUpScreen({super.key});

   final Controller appController = Get.find();
   
   OutlineInputBorder border(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) => appController.enableSignIn(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Obx(
          () => Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
          
                    // شعار التطبيق
                    Image.asset(
                      'images/dawak.png',
                      width: 200,
                      height: 200,
                    ),
                  
                    const SizedBox(height: 50),
          
                    // الاسم الكامل
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('الاسم الكامل:', 
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cairo'
                        )),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: appController.nameController,
                      
                      decoration: InputDecoration(
                        hintText: 'ادخل اسمك',
                         border: border(appController.nameHasError.value),
                        enabledBorder: border(appController.nameHasError.value),
                        focusedBorder: border(appController.nameHasError.value),
                        errorText: appController.nameHasError.value
                            ? 'الرجاء إدخال الاسم'
                            : null,
                            ),
                    ),
          
                    const SizedBox(height: 20),
          
                           // البريد الالكتروني
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('البريد الالكتروني:', 
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cairo'
                        ) ),
                    ),
                    const SizedBox(height: 6),
      
                    TextField(
                      controller: appController.emailController,           
                      decoration: InputDecoration(
                        hintText:  'ادخل البريد الالكتروني',
                        border: border(appController.emailHasError.value),
                        enabledBorder: border(appController.emailHasError.value),
                        focusedBorder: border(appController.emailHasError.value),
                        errorText: appController.emailHasError.value
                            ? 'البريد الإلكتروني غير صالح'
                            : null,
                          ),
                    ),
          
                    const SizedBox(height: 20),
          
                        // كلمة المرور
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('كلمة المرور:', 
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cairo'
                        )),
                    ),
                    const SizedBox(height: 6),
      
                    TextField(
                      controller: appController.passwordController,
                      decoration: InputDecoration(
                        hintText:  'ادخل كلمة المرور',
                        border: border(appController.passwordHasError.value),
                        enabledBorder: border(appController.passwordHasError.value),
                        focusedBorder: border(appController.passwordHasError.value),
                        errorText: appController.passwordHasError.value
                            ? 'كلمة المرور يجب أن تكون 9 أحرف على الأقل'
                            : null,
                        ),
                    ),
          
                    const SizedBox(height: 20),

                        // عنوان المنزل
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('عنوان المنزل:', 
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cairo'
                        )),
                    ),
                    const SizedBox(height: 6),
      
                    TextField(
                      controller: appController.addressController,
                      decoration: InputDecoration(
                        hintText:  'ادخل عنوانك كامل، مثال (الخرطوم - بحري - حلة خوجلي - شارع القبة)',
                        border: border(appController.addressHasError.value),
                        enabledBorder: border(appController.addressHasError.value),
                        focusedBorder: border(appController.addressHasError.value),
                        errorText: appController.addressHasError.value
                            ? 'العنوان يجب أن يكون 14 حرف على الأقل'
                            : null,
                        ),  ),

                        const SizedBox(height: 20),
          
                    // رقم الهاتف + زر التحقق
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('رقم الهاتف:', 
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cairo'
                        )),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            
                            controller: appController.phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText:  'ادخل رقمك',
                              border: border(appController.phoneHasError.value),
                              enabledBorder: border(appController.phoneHasError.value),
                              focusedBorder: border(appController.phoneHasError.value),
                              errorText: appController.phoneHasError.value
                            ? 'رقم الهاتف يجب أن يكون 9 أرقام على الأقل'
                            : null,
                            
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
      
                        ElevatedButton.icon(
                          onPressed: () => appController.validatePhoneNumber(),
      
                          icon: const Icon(Icons.verified, size: 20, color: Colors.white,),
                          label: const Text('أنقر للتحقق من الرقم', style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white
                          ),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 32, 119, 90),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
          
                    // زر التسجيل
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (appController.canSignUp.value) ? () {
      
                            appController.username = appController.nameController.text.trim();
                            appController.email = appController.emailController.text.trim();
                            appController.password = appController.passwordController.text.trim();
                            appController.phoneNumber = appController.phoneController.text.trim();
                            appController.address = appController.addressController.text.trim();
      
        if (appController.username.isEmpty || appController.email.isEmpty || 
            appController.password.isEmpty || appController.address.isEmpty || appController.phoneNumber.isEmpty) {
      appController.showErrorMsg('خطأ', 'جميع الحقول مطلوبة');
      return;
        }
      
        if (!GetUtils.isEmail(appController.email)) {
      appController.emailHasError.value = true;
      appController.showErrorMsg('خطأ', 'البريد الإلكتروني غير صالح');
      return;
        } else {
          appController.emailHasError.value = false;
        }
      
        if (appController.password.length < 9) {
      appController.passwordHasError.value = true;
      appController.showErrorMsg('خطأ', 'كلمة المرور يجب أن تكون 9 أحرف على الأقل');
      return;
        } else {
          appController.passwordHasError.value = false;
        }

        if(appController.address.length < 14) {
          appController.addressHasError.value = true;
          appController.showErrorMsg('خطأ', 'العنوان يجب أن يكون 14 حرف على الأقل');
          return;
        }
      
        if (!GetUtils.isPhoneNumber(appController.phoneNumber)) {
      appController.phoneHasError.value = true;
      appController.showErrorMsg('خطأ', 'رقم الجوال غير صالح');
      return;
        } else {
      appController.phoneHasError.value = false;
        }
      
        // إذا كانت كل الشروط مستوفاة، يتم التسجيل
        appController.registerUser(
      username: appController.username,
      email: appController.email,
      password: appController.password,
      phone: appController.phoneNumber,
      address: appController.address
        );
                            
                 } : null,
          
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 32, 119, 90),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),  ),

                        child:  Text(
                          'تسجيل',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                            ),  ),
                      )  ),
                    const SizedBox(height: 24),
          
                    // أو سجل عبر
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('او سجل عبر', style: TextStyle(
                            fontFamily: 'Cairo'
                          ),),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
          
                    // Apple & Google Sign In Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'images/apple-logo.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 6),
                            const Text('APPLE', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'images/google-logo.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 6),
                            const Text('GOOGLE', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
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