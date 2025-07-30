import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dawak/controller.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final Controller appController = Get.find();
  
  @override
  Widget build(BuildContext context) {
  

  return Scaffold(
      appBar: AppBar(
        title: Text('طلباتي', style: TextStyle(
          color: Color.fromARGB(255, 32, 119, 90),
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Obx(() {
        var orders = appController.orders;    

        return (orders.isEmpty) ? Center(child: Text('لا توجد طلبات حالياً', style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey
          ),)) : ListView.builder(
          itemCount: appController.orders.length,
          itemBuilder: (context, index) {

            final order = orders[index];
            final String orderId = order['orderId'] ?? 'غير معروف';
            final String medicineName = order['medicineName'] ?? 'غير محدد';
            final int price = (order['orderPrice'] ?? 0);
            String status = order['status'] ?? 'غير معروف';
            final dateValue = order['date'];
            String formattedDate = 'غير متاح';

            if(status == 'تم قبول الطلب') {
                appController.statusColor.value = Colors.green;
            } else if(status == 'تم رفض الطلب') {
                appController.statusColor.value = Colors.red;
            } else {
              appController.statusColor.value = Colors.blue;
            }

            

  if (dateValue != null) {
    if (dateValue is Timestamp) {
      formattedDate = DateFormat('dd-MM-yyyy').format(dateValue.toDate());
    } else if (dateValue is String) {
      final parsedDate = DateTime.tryParse(dateValue);
      if (parsedDate != null) {
        formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
      }
    } else if (dateValue is DateTime) {
      formattedDate = DateFormat('dd-MM-yyyy').format(dateValue);
    }
  }


            return Card(
              margin: EdgeInsets.all(20),
              child: ListTile(
                leading: Icon(Icons.medication, color: Colors.teal, size: 30,),
                title: Text('رقم الطلب: $orderId', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text('اسم الدواء: $medicineName'),
                    Text('السعر: ${price.toString()} SDG'),
                    Text('التاريخ: $formattedDate'),
                    Text('حالة الطلب: $status', style: TextStyle(color: appController.statusColor.value, fontWeight: FontWeight.bold),),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 30,),
                  onPressed: () async {
                    final confirm = await Get.dialog(
                      AlertDialog(
                        title: Text('تأكيد الحذف', textAlign: TextAlign.center),
                        content: Text('هل تريد حذف هذا الطلب؟', textAlign: TextAlign.center),
                        actions: [
                          TextButton(onPressed: () => Get.back(result: false), child: Text('إلغاء', style: TextStyle(
                            color: Colors.teal,
                          ),)),
                          TextButton(onPressed: () => Get.back(result: true), child: Text('حذف', style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold
                          ),)),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await appController.deleteOrder(order);
                      appController.showSuccessMsg('تم الحذف', 'تم حذف الطلب بنجاح');
                    }
                  },
                ),
              ),
            );
          },
        );
      }),
    );  }
}