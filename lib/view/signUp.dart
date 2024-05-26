import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/view/home.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("WELCOME"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(30),
            height: 50,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                signInGoogle(context);
              },
              child: Text(
                "Google SignUp",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future signInGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          await storeUserInfo(user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(user: user)),
          );
        }
      }
    } catch (e) {
      print("Error during Google sign in: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error during Google sign in: $e")));
    }
  }

  Future<void> storeUserInfo(User user) async {
    final userInfo = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userInfo.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    }, SetOptions(merge: true));
  }
}
