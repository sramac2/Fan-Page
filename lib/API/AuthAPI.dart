import 'package:firebase_auth/firebase_auth.dart';

class AuthAPI {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> LoginUserEmailPass(String email, String pwd) async {
    try {
      UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: pwd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password provided for that user.';
      }
    }
    return null;
  }

  Future<String> registerEmailPass(String email, String pwd) async {
    try {
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: pwd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
