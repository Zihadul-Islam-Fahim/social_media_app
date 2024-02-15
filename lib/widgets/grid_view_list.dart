import 'package:flutter/material.dart';
import 'package:food_app/controllers/create_post_controller.dart';

class GridviewList extends StatelessWidget {
  const GridviewList({
    super.key,
    required this.createPostController,
  });

  final CreatePostController createPostController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: createPostController.postList.length,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Card(
                      child: AspectRatio(
                        aspectRatio: 12 / 8,
                        child: Image.network(
                          createPostController.postList[index].photo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      createPostController.postList[index].title,
                      style: const TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    IconButton(onPressed: (){
                      createPostController.deletePost(createPostController.postList[index].photo, createPostController.postList[index].title);
                    }, icon: const Icon(Icons.delete_outlined),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
