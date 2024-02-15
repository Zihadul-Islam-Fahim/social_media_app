import 'package:flutter/material.dart';
import 'package:food_app/controllers/create_post_controller.dart';
import 'package:food_app/controllers/photo_upload_controller.dart';
import 'package:get/get.dart';

void homeBottomSheet(TextEditingController title) {
  Get.bottomSheet(
    BottomSheet(
      onClosing: () {},
      builder: (context) {
        return GetBuilder<PhotoUploadController>(
          builder: (PhotoUploadController controller) {
            return SingleChildScrollView(
              child: Container(
                height: Get.height*0.5,
              padding: const EdgeInsets.all(16),
                child: Column(

                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        controller.selectPhoto();
                      },
                      child: Container(
                        height: Get.height * 0.25,
                        width: Get.width * 0.7,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 3),
                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: (controller.currentImage != null)
                            ? Image.file(
                                controller.currentImage!,
                              )
                            : const Center(child: Text('Select an Image')),
                      ),
                    ),
                    const Spacer(),
                    TextFormField(
                      controller: title,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    const Spacer(),
                    GetBuilder<CreatePostController>(
                      builder: (CreatePostController createPostController) {
                        return Visibility(
                          visible: createPostController.loading == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                              onPressed: () async {
                                createPostController.createPost(title.text);
                                controller.currentImage = null;
                                title.clear();
                              },
                              child: const Text('Post')),
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
