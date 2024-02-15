import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:get/get.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String verificationID;

  const VerifyOtpScreen({super.key, required this.verificationID});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> verifyOtp() async {
    String otp = _otpTEController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationID,
      smsCode: otp,
    );
    try {
      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential).then(
        (value) {
          Get.offAll(const HomeScreen());
        },
      ).onError((error, stackTrace) {
            Get.showSnackbar(
              GetSnackBar(
                message: 'Failed',
                title: error.toString(),
                duration: const Duration(seconds: 2),
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
  }

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
                  height: size.height * 0.36,
                ),
                TextFormField(
                  maxLength: 6,
                  controller: _otpTEController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter OTP';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'OTP'),
                ),
                SizedBox(
                  height: size.height * 0.016,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        verifyOtp();
                      }
                    },
                    child: const Text('Signup')),
                SizedBox(
                  height: size.height * 0.1,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Have an account? login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
