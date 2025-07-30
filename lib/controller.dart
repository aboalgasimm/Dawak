import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dawak/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Controller extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();

  var screenIndex = 0.obs;
  // var numberOfPharmacies = 0.obs;
  var canSignUp = false.obs;
  var nameHasError = false.obs;
  var phoneHasError = false.obs;
  var emailHasError = false.obs;
  var passwordHasError = false.obs;
  var addressHasError = false.obs;
  var isLoading = true.obs;
  var isConnected = false.obs;
  var theUsername = ''.obs;

  var statusColor = Colors.blue.obs;
  RxBool obscurePassword = true.obs;
  RxBool isButtonClickable = false.obs;
  RxBool hasError = false.obs;
  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  String username = '', email = '', password = '', orderId = '', phoneNumber = '', address = '';

  
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Connectivity instance
  final Connectivity _connectivity = Connectivity();
  
  @override
  void onInit() {
    
    super.onInit();
    fetchUserData();
    // getPharmacyCount();
    fetchOrders();
    checkInternetConnection();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> resultList) {
  // Check if any connection is available
  bool hasConnection = resultList.any((result) => result != ConnectivityResult.none);
  isConnected.value = hasConnection;
});
  }

  // فحص الاتصال بالانترنت
  Future checkInternetConnection() async {
    var resultList = await _connectivity.checkConnectivity();
  bool hasConnection = resultList.any((result) => result != ConnectivityResult.none);
      isConnected.value = hasConnection;
    }

  // إنشاء حساب جديد
  void registerUser({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String address
  }) async {
    try {
      // إنشاء الحساب
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // حفظ البيانات في Firestore
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': username,
        'email': email,
        'phone': phone,
        'address': address,
      }).then((value) {
        enableSignIn();
        showSuccessMsg('تم تسجيل مستخدم جديد', 'تم إنشاء الحساب بنجاح');
        Get.offAll(LoginScreen()); // الانتقال إلى الصفحة الرئيسية بعد التسجيل
    });
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    }
  }


  void hideAndShowPassword() {
    obscurePassword.value = !obscurePassword.value;
  }


  // تسجيل الدخول
    void login() async {
   email = emailController.text.trim();
   password = passwordController.text.trim();

  // التحقق من صحة البريد الإلكتروني
  if (!GetUtils.isEmail(email)) {
    showErrorMsg('خطأ', 'البريد الإلكتروني غير صالح');
    emailHasError.value = true;
    return;
  } else {
    emailHasError.value = false;
  }

  // التحقق من طول كلمة المرور
  if (password.length < 8) {
    showErrorMsg('خطأ', 'كلمة المرور يجب أن تكون 8 أحرف على الأقل');
    passwordHasError.value = true;
    return;
  } else {
    passwordHasError.value = false;
  }


  try {
    
    await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) {
      fetchUserData();
      fetchOrders();
      showSuccessMsg('تم تسجيل الدخول بنجاح ✅', 'مرحبًا بك في تطبيق دواك');
      Get.offAll(HomeScreen());
    });
    
  } on FirebaseAuthException catch (e) {
    String message = '';

    switch (e.code) {
      case 'user-not-found':
        message = 'المستخدم غير موجود';
        break;

      case 'wrong-password':
        message = 'كلمة المرور غير صحيحة';
        passwordHasError.value = true;
        break;

      case 'invalid-email':
        message = 'البريد الإلكتروني غير صالح';
        emailHasError.value = true;
        break;

      case 'invalid-credential':
        message = 'تأكد جيداً من مطابقة البريد الإلكتروني مع كلمة المرور';
        emailHasError.value = true;
        passwordHasError.value = true;
        break;

      case 'network-request-failed':
        message = 'لا يوجد إتصال بالإنترنت';
        break;

      default:
        message = 'لا يمكن التسجيل : ${e.message}';
    }
    showErrorMsg('حدث خطأ أثناء تسجيل الدخول', message);
  } catch (e) {
    showErrorMsg('خطأ غير متوقع', e.toString());
  }    }


  // تسجيل الخروج
  void logout() async {
  try {
    emailController.clear();
    passwordController.clear();
    
    await FirebaseAuth.instance.signOut();
  
    Get.offAll(LoginScreen()); // يعيد المستخدم إلى شاشة تسجيل الدخول
  } catch (e) {
    showErrorMsg('خطأ', 'فشل تسجيل الخروج: ${e.toString()}');
  }
}


  void fetchUserData() async {
    try {
     

      final currentUser = auth.currentUser;
      if (currentUser != null) {
        final uid = currentUser.uid;
        final doc = await firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          username = doc.data()?['username'] ?? 'غير محدد';
          phoneNumber = doc.data()?['phone'] ?? 'غير محدد';
          email = doc.data()?['email'] ??  'لا يوجد ايميل';
          address = doc.data()?['address'] ?? 'غير محدد';
          theUsername.value = username;
          print("the username in home page is : ${theUsername.value}");
          print("username is : $username");
          print("phoneNumber is : $phoneNumber");
          print("email is : $email");
          print("address is : $address");

        } else {
          showErrorMsg('خطأ', 'بيانات المستخدم غير موجودة');
        }
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل البيانات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // تحديث عنوان المنزل
  void updateAddress(String userAddress) async {
    try {
      final currentUser = auth.currentUser;
      
      if(currentUser != null) {
        final uid = currentUser.uid;
        await firestore.collection('users').doc(uid).update(
          {"address": userAddress}).then((value) {
            fetchUserData();
            showSuccessMsg('تم التحديث بنجاح', 'تم تحديث عنوان المنزل');
          }).catchError((err) {
            showErrorMsg('حدث خطأ', 'لم يتم تحديث العنوان');
            } );
      }
    } catch (error) {
      showErrorMsg('حدث خطأ غريب', 'لا يمكن تحديث العنوان : ${error.toString()}');
    }
  }

  // تحديث رقم الهاتف
  void updatePhoneNumber(String userNumber) async {
    try {
      final currentUser = auth.currentUser;
      if(currentUser != null) {

        final uid = currentUser.uid;
        await firestore.collection('users').doc(uid).update(
          {"phone": userNumber}).then((value) {
            fetchUserData();
            showSuccessMsg('تم التحديث بنجاح', 'تم تحديث رقم الهاتف');
          }).catchError((err) {
            showErrorMsg('حدث خطأ', 'لم يتم تحديث الرقم');
            } );
      }
    } catch (error) {
      showErrorMsg('حدث خطأ غريب', 'لا يمكن تحديث الرقم : ${error.toString()}');
    }
  }


  // تنفيذ عملية شراء الدواء
//   Future<void> incrementUserOrders(String userId) async {
//   final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

//   await userRef.update({
//     'orders': FieldValue.increment(1),
//   });
// }

//   Future<void> callPharmacy(String phoneNumber) async {
//     try {
//       final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//   if (await canLaunchUrl(phoneUri)) {
//     await launchUrl(phoneUri);
//   }
//     } catch (e) {
//       print('لا يمكن إجراء الاتصال بالرقم: ${e.toString()}');
//     }   
// }

void callPharmacy(String phoneNumber) async {
  var url = Uri.parse("tel:$phoneNumber");
  if(await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    showErrorMsg('حدث خطأ', 'لا يمكن الاتصال بالرقم : $phoneNumber');
    throw 'Could not launch $url';
  }
}



  String generateOrderId() {
    final random = Random();
    int number = 100000 + random.nextInt(900000); // يضمن 6 أرقام تبدأ من 100000
  return number.toString();
}


  Future<void> createOrder({
    required String medicineName,
    required int price,
}) async {
   try {
    final userId = FirebaseAuth.instance.currentUser!.uid;
     orderId = generateOrderId();

    final newOrder = {
      'orderId': orderId, // ID يدوي بسيط
      'medicineName': medicineName,
      'orderPrice': price,
      'status': 'طلب جديد',
      'date': DateTime.now().toString(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
          'orders': FieldValue.arrayUnion([newOrder])
        });


    showSuccessMsg('عملية شراء جديدة', "✅ تم إضافة الطلب بنجاح");
  } catch (e) {
    showErrorMsg('title', "❌ خطأ أثناء إنشاء الطلب: $e");
  }
}


void fetchOrders() async {

    final currentUser = auth.currentUser;
    if(currentUser != null) {
      final currentUserId = currentUser.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null && data['orders'] != null) {
        orders.value = List<Map<String, dynamic>>.from(data['orders']);
      }
    }
    }
  }


  Future<void> deleteOrder(Map<String, dynamic> orderToDelete) async {
    if(currentUser != null) {
      final currentUserId = currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
      'orders': FieldValue.arrayRemove([orderToDelete]),
    });
    }
    

    // تحديث القائمة بعد الحذف
    fetchOrders();
  }

  

  // حذف حساب المستخدم
  void deleteUserAccount() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showErrorMsg('خطأ', 'لا يوجد مستخدم مسجّل حاليًا');
      return;
    }

    // حذف بيانات المستخدم من Firestore (اختياري حسب مكان تخزينك للبيانات)
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

    // حذف الحساب من Firebase Auth
    await user.delete();

    showErrorMsg('تم الحذف', 'تم حذف الحساب نهائيًا');
    Get.offAll(SplashScreen());
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      Get.snackbar('خطأ', 'لأسباب أمنية، يرجى تسجيل الدخول مرة أخرى أولًا ثم إعادة الحذف');
    } else {
      Get.snackbar('خطأ', e.message ?? 'حدث خطأ غير معروف');
    }
  } catch (e) {
    Get.snackbar('خطأ', 'فشل حذف الحساب: ${e.toString()}');
  }
}

  // حساب عدد الصيدليات المتوفرة
//   void getPharmacyCount() async {
//     try {
//       QuerySnapshot database = await FirebaseFirestore.instance.collection('pharmacy').get();

//       numberOfPharmacies.value = database.docs.length;

//       print('عدد الصيدليات هو: ${numberOfPharmacies.value}');
//     } catch (e) {
//     print('حدث خطأ أثناء جلب عدد الصيدليات: $e');
//   }
// }


// حساب عدد الطلبات
// void getUserOrderCount() async {
//   final userId = FirebaseAuth.instance.currentUser!.uid;

//   DocumentSnapshot userDoc = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userId)
//       .get();

//   // التأكد من وجود الحقل وأنه رقم
//   if (userDoc.exists && userDoc.data() != null) {
//     final data = userDoc.data() as Map<String, dynamic>;
//      orderCount.value = (data['orderCount'] ?? 0) as int;
//   }
// }




  void enableSignIn() {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        isButtonClickable.value = true;
    } else {
      isButtonClickable.value = false;
    }
  }


  void validatePhoneNumber() {
    phoneHasError.value = phoneController.text.trim().length < 8 || phoneController.text.contains(' ');
    if(phoneHasError.value) {
        Get.snackbar("الرقم غير صالح", "الرقم الذي أدخلته يجب أن يكون أكتر من 8 خانات من غير فراغ فاضي",  backgroundColor: Colors.red);
    } else {
      phoneNumber = phoneController.text;
      Get.to(VerificationScreen());
    }
  }
  
  @override
  void onClose() {
  nameController.dispose();
  phoneController.dispose();
  emailController.dispose();
  passwordController.dispose();
  super.onClose();
}

    void enableSignUp() {
      canSignUp.value = true;
  }

  void disableSignUp() {
      canSignUp.value = false;
  }

  void onItemTapped(int index) {
    screenIndex.value = index;
  }


  void showErrorMsg(String title, String msg) => Get.snackbar(title, msg,  backgroundColor: Colors.red, colorText: Colors.white);

  void showSuccessMsg(String title, String msg) => Get.snackbar(title, msg,  backgroundColor: Colors.green, colorText: Colors.white);

  void showLogoutConfirmation() {
  Get.defaultDialog(
    title: "تأكيد الخروج",
    middleText: "هل أنت متأكد أنك تريد الخروج من حسابك؟",
    textConfirm: "نعم",
    textCancel: "لا",
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.teal,
    buttonColor: Colors.teal,
    onConfirm: () {
      screenIndex.value = 0;
      // تنفيذ عملية تسجيل الخروج هنا
      Get.back(); // لإغلاق الـ dialog
      // مثال: الانتقال إلى صفحة تسجيل الدخول
      logout();
    },
    onCancel: () {
      Get.back(); // فقط إغلاق الرسالة بدون فعل أي شيء
    },
  );
}

  void showDeleteConfirmation() {
    Get.defaultDialog(
    title: "تأكيد حذف الحساب",
    middleText: "هل أنت متأكد أنك تريد حذف حسابك؟",
    textConfirm: "نعم",
    textCancel: "لا",
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.red,
    buttonColor: Colors.red,
    onConfirm: () {
      screenIndex.value = 0;
      // تنفيذ عملية تسجيل الخروج هنا
      Get.back(); // لإغلاق الـ dialog
      // مثال: الانتقال إلى صفحة تسجيل الدخول
      deleteUserAccount();
    },
    onCancel: () {
      Get.back(); // فقط إغلاق الرسالة بدون فعل أي شيء
    },
  );
}

   }