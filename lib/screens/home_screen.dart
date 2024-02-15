import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controllers/photo_upload_controller.dart';
import 'package:food_app/data/auth_data.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/screens/update_profile.dart';
import 'package:food_app/widgets/bottomsheet.dart';
import 'package:food_app/widgets/grid_view_list.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../controllers/create_post_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  CreatePostController createPostController = Get.find<CreatePostController>();
  final titleController = TextEditingController();

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAll(const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade600,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          homeBottomSheet(titleController);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: db
              .collection('users')
              .doc(firebaseAuth.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              createPostController.readyForPost(snapshot.data);
              AuthData.setUserDatafromFirestore(snapshot.data);
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.to(const UpdateProfile());
                    },
                    title: Text(
                      AuthData.userName,
                      style: TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      AuthData.useEmail,
                      style: TextStyle(fontFamily: 'poppins'),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        logout();
                      },
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child:
                          AuthData.photoUrl == 'null' || AuthData.photoUrl == ''
                              ? Image.asset(
                                  'assets/images/GOOG.png',
                                  width: 50,
                                )
                              : Image.network(
                                  AuthData.photoUrl,
                                  width: 60,
                                ),
                    ),
                  ),
                  Container(
                    height: Get.height * 0.88,
                    width: Get.width,
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Expanded(
                      child: GridviewList(createPostController: createPostController),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

