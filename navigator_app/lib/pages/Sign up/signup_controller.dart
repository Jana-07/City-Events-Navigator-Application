


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:navigator_app/services/authentication_reposity.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final fullname = TextEditingController();
  final email = TextEditingController();
  final Password = TextEditingController();
  final PhoneNo = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   registeteruser(String email, String password) async {
    try {
      UserCredential userCredential = await authenticationREposity.instance.createUserWithEmailAndPassword(email, password);
      if (userCredential.user != null) {
        // Save user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullname': fullname.text.trim(),
          'email': email.trim(),
          'phoneNo': PhoneNo.text.trim(),
          'createdAt': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}