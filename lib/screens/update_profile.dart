import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controllers/photo_upload_controller.dart';
import 'package:food_app/data/auth_data.dart';
import 'package:get/get.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final PhotoUploadController _uploadController =
  Get.find<PhotoUploadController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
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
              AuthData.setUserDatafromFirestore(snapshot.data);
              return Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                  Center(
                    child: Container(
                      height: Get.height * 0.6,
                      width: Get.width * 0.8,
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(40),
                          bottom: Radius.circular(40),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          _uploadController.selectPhoto();
                        },
                        child: GetBuilder<PhotoUploadController>(
                          builder: (controller) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: Get.height * 0.4,
                                  width: Get.width * 0.75,
                                  child: (controller.currentImage != null)
                                      ? Image.file(
                                    controller.currentImage!,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                    AuthData.photoUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.08,
                                ),
                                Visibility(
                                  visible: controller.loading == false,
                                  replacement:
                                  Center(child: CircularProgressIndicator()),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await _uploadController
                                            .uploadProfileImage();
                                      },
                                      child: const Text('Upload')),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
