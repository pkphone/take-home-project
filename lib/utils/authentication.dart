import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:take_home_project/screens/user_info_screen.dart';

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  // Initialize Firebase
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await Future.delayed(const Duration(seconds: 1));
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UserInfoScreen(
              user: user,
            ),
          ),
        );
      }.call();
    }

    return firebaseApp;
  }

  // Implement Google sign in
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    // check platform
    if (kIsWeb) {
      // web
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      // mobile
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            await Future.delayed(const Duration(seconds: 1));
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                Authentication.customSnackBar(
                  content:
                      'The account already exists with a different credential',
                ),
              );
            }.call();
          } else if (e.code == 'invalid-credential') {
            await Future.delayed(const Duration(seconds: 1));
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                Authentication.customSnackBar(
                  content:
                      'Error occurred while accessing credentials. Try again.',
                ),
              );
            }.call();
          }
        } catch (e) {
          await Future.delayed(const Duration(seconds: 1));
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content: 'Error occurred using Google Sign In. Try again.',
              ),
            );
          }.call();
        }
      }
    }

    return user;
  }

  // Implement Google sign out
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
