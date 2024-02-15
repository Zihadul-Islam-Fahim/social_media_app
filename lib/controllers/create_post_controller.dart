import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/controllers/photo_upload_controller.dart';
import 'package:get/get.dart';

import '../modal/post_modal.dart';

class CreatePostController extends GetxController{
  final CollectionReference db = FirebaseFirestore.instance.collection('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  PhotoUploadController photoUploadController = Get.find<PhotoUploadController>();
  bool loading = false;
  List<Post> postList = [];

  void readyForPost(data){
    postList.clear();
    for(Map p in data['posts']){
      Post post =Post(photo: p['photo'], title: p['title']);
      postList.add(post);
      log(p['photo']);
    }
  }

  void deletePost(image,title) async{
    db.doc(firebaseAuth.currentUser!.uid).update({
      'posts': FieldValue.arrayRemove(
        [
          {
            'photo': image,
            'title': title
          }
        ],
      )
    },);
  }

  void createPost(title)async{
    loading = true;
    update();
    String? image = await photoUploadController.uploadPostImage();
    db.doc(firebaseAuth.currentUser!.uid).update(
      {
        'posts': FieldValue.arrayUnion(
          [
            {
              'photo': image,
              'title': title
            }
          ],
        )
      },
    );
    loading = false;
    update();
    Get.back();
  }

}