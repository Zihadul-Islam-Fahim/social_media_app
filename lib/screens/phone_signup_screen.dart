import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/screens/verity_otp_screen.dart';
import 'package:get/get.dart';

class PhoneSignUp extends StatefulWidget {

  const PhoneSignUp({super.key});

  @override
  State<PhoneSignUp> createState() => _PhoneSignUpState();
}

class _PhoneSignUpState extends State<PhoneSignUp> {
  final TextEditingController _phoneTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> sendOtp() async {
    String phone = '+88${_phoneTEController.text}';
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          Get.showSnackbar(
            GetSnackBar(
              message: 'Failed',
              title: ex.toString(),
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
            ),
          );
        },
        codeSent: (verificationID, resendToken) {
          Get.to( VerifyOtpScreen(verificationID: verificationID,));
        },
        codeAutoRetrievalTimeout: (verificationID) {},
        timeout: const Duration(seconds: 30));
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
                  controller: _phoneTEController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Phone Number';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Phone'),
                ),

                SizedBox(
                  height: size.height * 0.016,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendOtp();
                      }
                    },
                    child: const Text('Send OTP')),
                SizedBox(
                  height: size.height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dispose() {
    _phoneTEController.dispose();
    super.dispose();
  }
}
