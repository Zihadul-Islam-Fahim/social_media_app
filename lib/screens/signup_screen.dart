import 'package:flutter/material.dart';
import 'package:food_app/controllers/signin_controller.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.3,
                ),
                TextFormField(
                  controller: _nameTEController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Name';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Name',hintStyle: TextStyle(fontFamily: 'poppins'),),
                ),
                SizedBox(
                  height: Get.height * 0.016,
                ),
                TextFormField(
                  controller: _emailTEController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email address';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Email',hintStyle: TextStyle(fontFamily: 'poppins'),),
                ),
                SizedBox(
                  height: Get.height * 0.016,
                ),
                TextFormField(
                  controller: _phoneTEController,
                  validator: ( value) {
                    if (value!.isEmpty) {
                      return 'Enter Phone Number';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Phone',hintStyle: TextStyle(fontFamily: 'poppins'),),
                ),
                SizedBox(
                  height: Get.height * 0.016,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Password',hintStyle: TextStyle(fontFamily: 'poppins'),),
                ),
                SizedBox(
                  height: Get.height * 0.016,
                ),
                GetBuilder<SignInController>(
                    builder: (SignInController controller) {
                  return SizedBox(
                    height: Get.height * 0.06,
                    width: Get.width,
                    child: Visibility(
                      visible: controller.loading == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orangeAccent,
                        ),
                      ),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.signup(
                                  _nameTEController.text.trim(),
                                  _emailTEController.text.trim(),
                                  _phoneTEController.text.trim(),
                                   _passwordTEController.text);
                            }
                          },
                          child: const Text('Sign up',style: TextStyle(fontFamily: 'poppins', fontWeight: FontWeight.w600,fontSize: 15),)),
                    ),
                  );
                }),
                SizedBox(
                  height: Get.height * 0.1,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Have an account? ',style: TextStyle(fontFamily: 'poppins',fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey),),
                        const Text(' Login',style: TextStyle(fontSize: 14,fontFamily:'poppins',fontWeight: FontWeight.w700,)),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _phoneTEController.dispose();
    _nameTEController.dispose();
    _emailTEController.dispose();
    super.dispose();
  }
}
