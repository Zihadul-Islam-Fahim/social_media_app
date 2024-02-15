import 'package:firebase_auth/firebase_auth.dart';

class AuthData {
  static String userID = '';
  static String userName = '';
  static String useEmail = '';
  static String photoUrl = '';
  static String phone = '';

  static void setUserDatafromFirestore(var userData) {

    AuthData.userName = userData['name'];
    AuthData.useEmail = userData['email'];
    AuthData.phone = userData['phone'];
    AuthData.photoUrl = userData['photoUrl'];
  }
}
