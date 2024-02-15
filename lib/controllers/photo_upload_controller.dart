import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadController extends GetxController {
  bool loading = false;
  File? currentImage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? postPhotoUrl;

  selectPhoto() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 20);
    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);
      currentImage = convertedFile;
      update();
    }
  }

  Future<void> uploadProfileImage() async {
    loading = true;
    update();
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('UserProfilePictures')
        .child(firebaseAuth.currentUser!.uid)
        .putFile(currentImage!);
    TaskSnapshot taskSnapshot = await uploadTask;

    String profilePicUrl = await taskSnapshot.ref.getDownloadURL();
    updateUserInfo(profilePicUrl);
  }

  Future<void> updateUserInfo(picUrl) async {
    await _firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'photoUrl': picUrl});
    loading = false;
    currentImage = null;
    update();
    Get.back();
  }

  Future<String?> uploadPostImage() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('UsersPostsImages')
        .child(DateTime.now().second.toString())
        .putFile(currentImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    postPhotoUrl = await taskSnapshot.ref.getDownloadURL();
    return postPhotoUrl;
  }
}
