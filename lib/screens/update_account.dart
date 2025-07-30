import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';
class UpdateAccountScreen extends StatelessWidget {
  final Controller appController = Get.find();
   UpdateAccountScreen({super.key});

  OutlineInputBorder border(bool hasError) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 32, 119, 90),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text('تحديث بيانات المستخدم'),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
             // crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
                
              children: [
                      // عنوان المنزل
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                Icon(Icons.location_city, color: Color.fromARGB(255, 32, 119, 90), size: 30),
                                SizedBox(width: 10),
                                Text('عنوان المنزل:',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Cairo'
                                  )),
                              ],
                            ),
                          ),
                           SizedBox(height: 6),
            
                          TextField(
                            controller: appController.addressController,
                            decoration: InputDecoration(
                              hintText:  'ادخل عنوانك الجديد',
                              
                              border: border(appController.addressHasError.value),
                              enabledBorder: border(appController.addressHasError.value),
                              focusedBorder: border(appController.addressHasError.value),
                              errorText: appController.addressHasError.value
                                  ? 'العنوان يجب أن يكون 14 حرف على الأقل'
                                  : null,
                              ),  ),
                
                              SizedBox(height: 16),
            
                              // زر تحديث العنوان
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 32, 119, 90),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),  ),
                                  onPressed: () {
                                    if(appController.addressController.text.isEmpty) {
                                      appController.showErrorMsg('فشل التحديث', 'لا يمكن أن يكون العنوان فارغ');
                                      return;
                                    }

                                    if(appController.addressController.text.length < 14) {
                                      appController.showErrorMsg('فشل التحديث', 'العنوان يجب أن يكون 14 حرف على الأقل');
                                      return;
                                    }
                                    appController.updateAddress(appController.addressController.text);
                                  }, 
                                  child: Text('تحديث العنوان', style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                  ),)
                                  )  ),
            
                              SizedBox(height: 26),
            
                              // رقم الجوال
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                Icon(Icons.phone_android, color: Color.fromARGB(255, 32, 119, 90), size: 30),
                                SizedBox(width: 10),
                                Text('رقم الجوال:',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Cairo'
                                  )),
                              ],
                            ),
                          ),
            
                          SizedBox(height: 6),
            
                              TextField(
                                  
                                  controller: appController.phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText:  'ادخل رقمك الجديد',
                                    
                                    border: border(appController.phoneHasError.value),
                                    enabledBorder: border(appController.phoneHasError.value),
                                    focusedBorder: border(appController.phoneHasError.value),
                                    errorText: appController.phoneHasError.value
                                  ? 'رقم الهاتف يجب أن يكون 9 أرقام على الأقل'
                                  : null,
                                  
                                  )  ),
                
                                  SizedBox(height: 16),
                
                      // زر تحديث الرقم
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 32, 119, 90),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),  ),
                                  onPressed: () {

                                    if(appController.phoneController.text.isEmpty) {
                                      appController.showErrorMsg('فشل التحديث', 'لا يمكن أن يكون رقم الهاتف فارغ');
                                      return;
                                    }

                                    if(appController.phoneController.text.length < 9) {
                                      appController.showErrorMsg('فشل التحديث', 'رقم الهاتف يجب أن يكون 9 أرقام على الأقل');
                                      return;
                                    }

                                    appController.updatePhoneNumber(appController.phoneController.text);
                                  },
                                  child: Text('تحديث الرقم', style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                  ),)
                                  )  ),
            
            
              ],
            ),
          ),
        ),
      );
    
  }
}