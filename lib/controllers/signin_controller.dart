import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool loading = false;

  Future<void> signup(name, email, phone, password) async {
    loading = true;
    update();
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
          Get.showSnackbar(
            const GetSnackBar(
              message: 'Success',
              title: 'User Created Successfully',
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
            ),
          );
          saveToFireStore(name, email, phone);
        },
      ).onError((error, stackTrace) {
          Get.showSnackbar(
            GetSnackBar(
              message: error.toString(),
              title: 'Failed',
              duration: const Duration(seconds: 4),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
            ),
          );
        },
      );
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
    loading = false;
    update();
  }

  Future<void> saveToFireStore(name, email, mobile,{String photoUrl=''}) async {
   await  _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .set(
      {'name': name, "email": email, 'phone': mobile ,'photoUrl': photoUrl,'posts':[]},
    );

    Get.offAll(const HomeScreen());
  }
}
