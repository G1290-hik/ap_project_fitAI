import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:h2s/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h2s/screens/HomeScreen.dart';

class AuthService {
  //Handles Auth
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        });
  }

  //Sign out
 Future signOut() async {
   await FirebaseAuth.instance.signOut();
  }

  //Save to device
  Future<void> savePhoneNumber(String phno) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('Phone Number', phno);
    
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
    print(authCreds);
  }

  signInWithOTP(smsCode, verId) async{
    AuthCredential authCreds = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: smsCode);
   await signIn(authCreds);

  }


}