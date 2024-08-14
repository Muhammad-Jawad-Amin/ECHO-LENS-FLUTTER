import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Timer? timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // Login with email and password
  Future<User?> login(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> loginWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null; // The user canceled the sign-in
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    return user;
  }

  void startEmailVerificationCheck(Function onVerified, String email) async {
    stopEmailVerificationCheck();
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        await user?.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user != null && user!.emailVerified) {
          stopEmailVerificationCheck();
          onVerified();
        }
      });
    }
  }

  Future<String> passwordRest(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Password reset email has been sent. Please check your inbox.';
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else {
        message = 'An error occurred. Please try again later.';
      }
      return message;
    }
  }

  Future<void> deleteUserIfNotVerified() async {
    stopEmailVerificationCheck();
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.delete();
    }
    await FirebaseAuth.instance.signOut();
  }

  void stopEmailVerificationCheck() {
    timer?.cancel();
  }

  String getuserId() {
    return _auth.currentUser!.uid;
  }

  String getuserEmail() {
    return _auth.currentUser!.email!;
  }

  User? getcurrentUser() {
    return _auth.currentUser;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
