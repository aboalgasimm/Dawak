import 'package:dawak/screens/update_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});
   final Controller appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (appController.isLoading.value) ? Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 14, 149, 138),
                  radius: 40,
                  child: Icon(Icons.person, size: 50, color: Colors.white,),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appController.username, style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo'
                      )),
      
                      SizedBox( height: 5, ),
      
                    Text(appController.email, style: TextStyle(
                      fontSize: 15, 
                      color: Colors.grey[700],
                      fontFamily: 'Cairo'
                      )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
      
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text('رقم الهاتف', style: TextStyle(fontFamily: 'Cairo') ),
              subtitle: Text(appController.phoneNumber, style: TextStyle(fontFamily: 'Cairo') ),
            ),

            ListTile(
              leading: const Icon(Icons.location_city),
              title: Text('العنوان', style: TextStyle(fontFamily: 'Cairo') ),
              subtitle: Text(appController.address, style: TextStyle(fontFamily: 'Cairo') ),
            ),
      
            ListTile(
              leading: const Icon(Icons.manage_accounts_sharp),
              title: Text('تحديث بيانات الحساب', style: TextStyle(fontFamily: 'Cairo') ),
              onTap: () { 
                appController.addressController.clear();
                appController.phoneController.clear();
                Get.to(UpdateAccountScreen());
                 },
            ),
      
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal,),
              title: Text('تسجيل الخروج', style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.teal
                ) ),
              onTap: () {
                appController.showLogoutConfirmation();
              },  ),
      
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red,),
              title: Text('حذف الحساب', style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.red
                ) ),
              onTap: () {
                appController.showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }
}