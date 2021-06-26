import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Models/User.dart' as models;

class AuthAPI {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ],
  );

  Future<String> loginUserEmailPass(String email, String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
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
      UserCredential userCredential = await FirebaseAuth.instance
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

  Future<String> logout() async {
    await FirebaseAuth.instance.signOut();
    _googleSignIn.disconnect();
    return null;
  }

  Future<String> googleSignIn() async {
    try {
      
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
      return error.toString();
    }
    return null;
  }

  Future<String> createUser(models.User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await users
        .add(user.toJson())
        .then((value) => null)
        .catchError((error) => error.toString());
  }

  Future<models.User> findUserbyId(String uid) async{
    
    List<models.User> result = [];
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.where("uid",isEqualTo: uid).get();
    for (var doc in querySnapshot.docs) {
      result.add(
        models.User.fromJson(
          doc.data(),
        ),
      );
    }
    return result.isEmpty ?null: result[0];
  }
}
