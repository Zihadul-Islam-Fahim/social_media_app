import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
  bool loading = false;
  Future<void> login(email,password) async {
    loading = true;
    update();
    try {
      UserCredential? userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: password)
          .then(
            (value) {
          Get.showSnackbar(
            const GetSnackBar(
              message: 'Success',
              title: 'Login Success',
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
            ),
          );
          Get.offAll(const HomeScreen());
        },
      ).onError(
            (error, stackTrace) {
          Get.showSnackbar(
             const GetSnackBar(
              message: 'Failed',
              title: 'Login failed',
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
            ),
          );
        },
      );
      loading = false;
      update();
    } on FirebaseAuthException catch (ex) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Failed',
          title: ex.toString(),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}