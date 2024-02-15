import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:food_app/controllers/signin_controller.dart';
import 'package:food_app/data/auth_data.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  CollectionReference db = FirebaseFirestore.instance.collection('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Map<String, dynamic>? _userData;

  Future<void> handleSignIn() async {
    try {
      GoogleSignInAccount? _user = await _googleSignIn.signIn();
      if (_user != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await _user.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(credential);

        checkHasUser();
      }
    } on FirebaseException catch (ex) {
      GetSnackBar(
        message: 'Failed',
        title: ex.toString(),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<UserCredential> signInFacebook() async {
    final LoginResult loginResult =
        await FacebookAuth.instance.login(permissions: ['email']);
    if (loginResult == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
    } else {
      GetSnackBar(
        message: 'Failed',
        title: loginResult.message.toString(),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
    final AuthCredential authCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  signinWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }




  Future<void> checkHasUser()async{
    List dataList=[];
    bool? previousUser ;
    QuerySnapshot querySnapshot = await db.get();
    querySnapshot.docs.forEach((doc) {
      dataList.add(doc.data());
    });

    for(int i = 0;i<dataList.length;i++){
      if(dataList[i]['email'].toString() == _auth.currentUser!.email.toString()){
        previousUser = true;
        Get.offAll(const HomeScreen());
        break;
      }else{
        previousUser= false;
      }
    }

    if(previousUser == true){
      Get.offAll(const HomeScreen());
    }else{
     await Get.find<SignInController>().saveToFireStore(
        firebaseAuth.currentUser!.displayName.toString(),
        firebaseAuth.currentUser!.email.toString(),
        firebaseAuth.currentUser!.phoneNumber.toString(),
        photoUrl: firebaseAuth.currentUser!.photoURL.toString(),
      );
      Get.offAll(const HomeScreen());
    }
  }

}


