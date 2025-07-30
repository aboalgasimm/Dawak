import 'package:dawak/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:dawak/controller.dart';

class PurchaseSuccessScreen extends StatelessWidget {
  final String orderId;
  final String medicineName;
  final String medicineDescription;
  final int medicinePrice;
  final String medicineImage;

  final Controller appController = Get.find();

   PurchaseSuccessScreen({
    super.key,
    required this.orderId,
    required this.medicineName,
    required this.medicineDescription,
    required this.medicinePrice,
    required this.medicineImage,
  });

  // إنشاء الفاتورة PDF
  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('فاتورة الشراء', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('رقم الطلب: $orderId'),
            pw.Text('اسم الدواء: $medicineName'),
            pw.Text('الوصف: $medicineDescription'),
            pw.Text('السعر: ${medicinePrice.toString()} SDG'),
            pw.SizedBox(height: 30),
            pw.Text('شكرًا لثقتكم بنا!', style: pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),

          child: Column(
           
            children: [

              // ✅ لوتي أنيميشن نجاح
              Lottie.asset('assets/success.json', height: 180),

              const SizedBox(height: 20),

              Text(
                'تم الشراء بنجاح!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),

              SizedBox(height: 10),

              Text(
                'رقم الطلب: $orderId',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 20),

              // 🖼️ عرض صورة الدواء
              Image.network(medicineImage, height: 120,),


              Text(
                medicineName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),

              const SizedBox(height: 8),

              Text(
                medicineDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                '$medicinePrice SDG',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // 📄 زر الفاتورة PDF
              ElevatedButton.icon(
                onPressed: () => _generatePdf(context),
                icon: Icon(Icons.picture_as_pdf),
                label: Text('عرض الفاتورة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),

              const SizedBox(height: 20),

              // 🏠 زر العودة
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: () {
                    appController.fetchOrders();
                    Get.offAll(HomeScreen());
                  },
                  
                  label: Text('العودة إلى الصفحة الرئيسية'),
                  icon: Icon(Icons.home, size: 25,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 32, 119, 90),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),  ),

            const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}