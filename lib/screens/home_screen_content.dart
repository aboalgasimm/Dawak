import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dawak/screens/map_screen.dart';
import 'package:dawak/screens/medicine_screen.dart';
import 'package:flutter/material.dart';
import 'package:dawak/controller.dart';
import 'package:get/get.dart';
import 'chatbot_screen-V2.dart';

class HomeScreenContent extends StatelessWidget {
   HomeScreenContent({super.key});
    final Controller appController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          drawer: Drawer(
        
                child: Obx(
                  () => ListView(
                    children: [
                      Center(
                        child: UserAccountsDrawerHeader(
                          decoration:  BoxDecoration(color: Colors.teal[700]),
                          accountName: Text(appController.theUsername.value, style: TextStyle(fontFamily: 'Cairo')),
                          accountEmail: Text(appController.email, style: TextStyle(fontFamily: 'Cairo')),
                          currentAccountPicture:  CircleAvatar(
                            child: Icon(Icons.person, size: 40,),
                          )  ),
                      ),
                          
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text('الملف الشخصي', style: TextStyle(fontFamily: 'Cairo')),
                        onTap: () {
                          appController.onItemTapped(2);
                        },
                      ),
                          
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text('الإعدادات', style: TextStyle(fontFamily: 'Cairo')),
                        onTap: () {},
                      ),
                          
                      ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text('الطلبات', style: TextStyle(fontFamily: 'Cairo')),
                        onTap: () {
                          appController.onItemTapped(1);
                        },
                      ),
                          
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: Text('عن التطبيق', style: TextStyle(fontFamily: 'Cairo')),
                        onTap: () {},
                      ),
                          
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.teal,),
                        title: Text('تسجيل الخروج', style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Colors.teal
                          )),
                        onTap: () {
                          appController.showLogoutConfirmation();
                        },
                      ),
                    ],
                  ),
                ),  ),
          body:   Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // زر القائمة الجانبية
                                Builder(
                                  builder: (context) => CircleAvatar(
                                    backgroundColor: Colors.teal[700],
                                    radius: 25,
                                    child: IconButton(
                                    icon: const Icon(Icons.menu, size: 33, color: Colors.white),
                                    onPressed: () {
                                      
                                      Scaffold.of(context).openDrawer();
                                },    ),
                                ),    ),
                  
                                 Text('حبابك في تطبيق دواك', style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold
                                  ),  ),
                               
                  
                                Image.asset('images/dawak.png', width: 80, height: 80),
                           
                              ],
                            )  ),
                  
                          const SizedBox(height: 32),
                  
                          Expanded(
                            child: StreamBuilder<QuerySnapshot> (
                              stream: FirebaseFirestore.instance.collection('pharmacy').snapshots(),
              builder: (context, snapshot) {
               
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
      
            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            }
      
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('لا توجد صيدليات حالياً'));
            }
      
            final pharmacies = snapshot.data!.docs;
            
                              return  ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                                  itemCount: pharmacies.length,
                                  itemBuilder: (context, index) {
                                    var data = pharmacies[index].data() as Map<String, dynamic>;
                                    String name = data['name'] ?? 'بدون اسم';
                                    String location = data['location'] ?? 'غير محدد';
                                    String phone = data['phone_number'] ?? 'غير متوفر';
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 15),
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 32, 119, 90),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            name,
                                            style:  TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),  ),
                                            
                                          const SizedBox(height: 4),
                                           Text(
                                            location,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(phone, style: TextStyle(
                                            fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                          ),),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.to(MedicineScreen(pharmacyName: name, pharmacyNumber: phone,));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.teal[700],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text('اعرض الأدوية', style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            ),),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                        );
                             
                            
      }  ),
                          ),
                          
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 60),
                              child: ElevatedButton.icon(
                                onPressed: () { Get.to(MapScreen());  },
                                icon:  Icon(Icons.location_on_outlined, size: 25,),
                                label:  Text('اعرض الصيدليات القريبة مني', style: TextStyle(
                                  fontFamily: 'Cairo'
                                ),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[200],
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),  ),
                            ),  ),
                        ],    ),
            
          
        
        floatingActionButton: FloatingActionButton(
                  
                  child: Image.asset('images/robot.png'),
                  onPressed: () {
                    Get.to(ChatBotScreenV2());
                  }
                  ),
                floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
       
    );
    
  }
}
