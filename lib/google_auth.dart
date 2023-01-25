import 'package:notes_taking_apps_online/screen/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth=FirebaseAuth.instance;
CollectionReference users=FirebaseFirestore.instance.collection('users');
  void signInWithGoogle(BuildContext context) async {
  // Trigger the authentication flow
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    if (googleUser != null) {
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

final UserCredential authResult=await  auth.signInWithCredential(credential);
final User? user=authResult.user;
var userData={
  'name':googleUser.displayName,
  'email':googleUser.email,
  'id':googleUser.id


};
  
users.doc(user?.uid).get().then((doc){
  if(doc.exists){
    doc.reference.update(userData);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(),
    ),
    );
  

  }
    //For new User

  else{
    users.doc(user?.uid).set(userData);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>HomePage()));
  }

} );




    }
  }
  catch(PlatfromException){
    print(PlatfromException);
    print("Login is not sucessful");
  }
  }