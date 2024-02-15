import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/auth_service/auth_services.dart';
import 'package:food_app/controllers/login_controller.dart';
import 'package:food_app/screens/phone_signup_screen.dart';
import 'package:food_app/screens/signup_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthServices services = AuthServices();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.32,
                ),
                TextFormField(
                  controller: _emailTEController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email address';
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(fontFamily: 'poppins')),
                ),
                SizedBox(
                  height: size.height * 0.016,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Password';
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(fontFamily: 'poppins'),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.016,
                ),
                GetBuilder<LoginController>(builder: (controller) {
                  return Visibility(
                    visible: controller.loading == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: SizedBox(
                      height: Get.height * 0.065,
                      width: Get.width,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.login(
                                _emailTEController.text,
                                _passwordTEController.text,
                              );
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                    ),
                  );
                }),
                SizedBox(
                  height: size.height * 0.12,
                ),
                Card(
                  elevation: 5,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(const PhoneSignUp());
                    },
                    child: const Text(
                      'Login with Phone Number',
                      style: TextStyle(
                          fontFamily: 'poppins', fontWeight: FontWeight.w600),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    AuthServices().handleSignIn();
                  },
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      height: size.height * 0.07,
                      width: size.width * 0.62,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '  Login with Google     ',
                              style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w600),
                            ),
                            Image.asset(
                              'assets/images/GOOG.png',
                              width: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                TextButton(
                  onPressed: ()async {

                    Get.to(const SignupScreen());
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t have an account? ',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
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
    _emailTEController.dispose();
    super.dispose();
  }
}
