import 'package:dawak/controller.dart';
import 'package:dawak/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.teal[800], // لون الشريط السفلي
    systemNavigationBarIconBrightness: Brightness.light, // لون الأيقونات
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

    final FirebaseAuth auth = FirebaseAuth.instance;

   MyApp({super.key});

   final Controller appController = Get.put(Controller());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'دواك',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      
      // إذا كان المستخدم عنده حساب بنتقل على طول للصفحة الرئيسية، أما إذا ما عنده بنتقل لصفحة تسجيل الدخول

      home: (auth.currentUser == null)  ?  SplashScreen() : HomeScreen(),
    );
  }
}
