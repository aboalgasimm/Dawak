import 'package:flutter/material.dart';
import 'home_screen_content.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class HomeScreen extends StatelessWidget {
  final Controller appController = Get.find();
  
   HomeScreen({super.key});

    final List<Widget> pages = [
     HomeScreenContent(),
     OrdersScreen(),
     ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(
        () => Scaffold(
        
            body: SafeArea(child: pages[appController.screenIndex.value]),
        
            
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: appController.screenIndex.value,
              onTap: appController.onItemTapped,
              selectedItemColor: Colors.teal[700],
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
                BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'الطلبات'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
              ],  ),
          ),
      ),
    );
  }
}