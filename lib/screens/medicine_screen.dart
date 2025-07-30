import 'package:dawak/screens/confirm_medicine_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class MedicineScreen extends StatelessWidget {
  MedicineScreen({required this.pharmacyName, required this.pharmacyNumber});
  final Controller appController = Get.find();
  final String pharmacyName;    // اسم الصيدلية المستهدفة
  final String pharmacyNumber;  // رقم الصيدلية المستهدفة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pharmacyName, style: TextStyle(
          color: Color.fromARGB(255, 32, 119, 90),
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,

      actions: [
        Padding(
          padding: const EdgeInsets.only( right: 10),
          child: IconButton(
            onPressed: () { appController.callPharmacy(pharmacyNumber); },
            icon: Icon(Icons.phone_in_talk, color: Color.fromARGB(255, 32, 119, 90),)),
        )
      ],
      ),
      body: (appController.isConnected.value) ? StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pharmacy')
            .where('name', isEqualTo: pharmacyName)
            .snapshots(),
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

          // ✅ نقوم بتجميع العناصر هنا في كل build
          List<Widget> medicineWidgets = [];

          for (var pharmacyDoc in snapshot.data!.docs) {
            final pharmacyData = pharmacyDoc.data() as Map<String, dynamic>;

            if (pharmacyData.containsKey('medicines') &&
                pharmacyData['medicines'] is List) {
              List medicines = pharmacyData['medicines'];

              for (var med in medicines) {
                medicineWidgets.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      margin: EdgeInsets.all(10),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Column(
                              children: [
                                Image.network(
                                  med['picture'] ?? '',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  (med['isAvailable'] ?? false)
                                      ? 'متوفر'
                                      : 'غير متوفر',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: (med['isAvailable'] ?? false)
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),  ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:  15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      med['name'] ?? 'اسم غير متوفر',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      med['description'] ?? 'بدون وصف',
                                      maxLines: 15,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'Cairo'),
                                    
                                    )  ),
                              
                                  SizedBox(height: 25),
                              
                                  Center(
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "${med['price'] ?? '0'} SDG",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ),
                               
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: (med['isAvailable'] == true) ? () {
                              Get.to( ConfirmMedicineScreen(
                               
                                name: med['name'],
                                description: med['description'],
                                imageUrl: med['picture'],
                                price: med['price']));
                            } : null,
                            icon:  (med['isAvailable'] == true) ? Icon(Icons.medical_services, color: Colors.green[700]) : Icon(Icons.medical_services, color: Colors.grey.shade400),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          }

          return medicineWidgets.isEmpty
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
            //    crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                        'لا يوجد أدوية متوفرة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              )
              : ListView(
                  padding: EdgeInsets.all(10),
                  children: medicineWidgets,
                );
        },
      ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'images/no_internet.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      
                        'لا يوجد إتصال بالإنترنت',
                        
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    )  )
                ]  )
    );
  }
}


/*
Panadol Comp Url:
https://firebasestorage.googleapis.com/v0/b/khidma-aa661.appspot.com/o/all%20medicines%2FPanadol%20Comp.png?alt=media&token=0bc5e17d-c5cd-4a3a-ab66-d8af7079f8b0

Panadol Advance Url:
https://firebasestorage.googleapis.com/v0/b/khidma-aa661.appspot.com/o/all%20medicines%2FPanadol%20Advance.png?alt=media&token=da357e38-65c4-419f-9b8a-3f77ea8a7b1f

Panadol Night Url:
https://firebasestorage.googleapis.com/v0/b/khidma-aa661.appspot.com/o/all%20medicines%2FPanadol%20Night.png?alt=media&token=76e1f375-ef06-46fc-897c-3068f9fadd9d

*/