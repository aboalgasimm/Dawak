import 'package:dawak/screens/purchase_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class ConfirmMedicineScreen extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final int price;

  final Controller appController = Get.find();

   ConfirmMedicineScreen({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد الشراء', style: TextStyle(
          fontWeight: FontWeight.bold,
         color:  Color.fromARGB(255, 32, 119, 90)
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // صورة الدواء
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100),
                ),
              ),

              const SizedBox(height: 20),

              // اسم الدواء
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // وصف الدواء
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Cairo',
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // السعر
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${price.toString()} SDG',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),

              // زر التأكيد
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // تنفيذ عملية الشراء هنا
                      appController.createOrder(
                        medicineName: name,
                        price: price).then((val) {
                          Get.offAll(PurchaseSuccessScreen(
                            orderId: appController.orderId,
                            medicineName: name,
                            medicineDescription: description, 
                            medicinePrice: price, 
                            medicineImage: imageUrl));
                        }).catchError((onError) {
                          appController.showErrorMsg('فشل عملية الشراء', onError.toString());
                          });

                      
                    },
                    icon: const Icon(Icons.check_circle, size: 25,),
                    label:  Text('تأكيد الشراء', style: TextStyle(fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 32, 119, 90),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}