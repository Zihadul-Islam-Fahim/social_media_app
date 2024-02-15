import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controllers/create_post_controller.dart';
import 'package:food_app/controllers/login_controller.dart';
import 'package:food_app/controllers/photo_upload_controller.dart';
import 'package:food_app/controllers/signin_controller.dart';
import 'package:food_app/screens/auth_screen.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main()async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const FoodApp());

 }


class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.teal, width: 2)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16)
          )
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20)
          )
        )
      ),
      home: AuthScreen(),
       initialBinding: BindingController(),
    );
  }
}

class BindingController extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(LoginController());
    Get.put(PhotoUploadController());
    Get.put(CreatePostController());
  }

}