

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:navigator_app/pages/login/login_screen.dart';
import 'package:navigator_app/pages/Sign up/signup_email_password_failure.dart';
import 'package:navigator_app/pages/Sign up/signup_screen.dart';

class authenticationREposity extends GetxController{
  static authenticationREposity get instance => Get.find();


  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;


  @override
  void onReady(){
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }


 _setInitialScreen(User? user) {
  user == null ? Get.offAll(() => const LoginScreen()) : Get.offAll(() => const SignUpScreen());

}

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
  }
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print("No user is currently logged in.");
      return null;
    }

    String uid = user.uid;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      print("User data not found.");
      return null;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password)async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){} catch (_){}
  }


  Future<void> logout() async => await _auth.signOut();

}