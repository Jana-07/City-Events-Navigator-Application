import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navigator_app/services/database.dart';

class AuthMethod{

  final FirebaseAuth auth= FirebaseAuth.instance;

  getCurrentUser()async{
    return await auth.currentUser;

  }
singInWithGoogle(BuildContext context) async{
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;
    if(result != null){
      Map<String, dynamic> userInfoMap={
       "Name" : userDetails!.displayName,
        "Image": userDetails.photoURL,
        "Email": userDetails.email,
        "id": userDetails.uid
      };
      await DatabaseMethods().addUserDetail(userInfoMap, userDetails.uid);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.green,
                content: Text("Registered successfully")
        ));
    }


}

}