//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_tune/models/user.dart';
import 'package:core_tune/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      FirebaseUser firebaseUser = result.user as FirebaseUser;
      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "test@example.com", password: "testing");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  MUser? _userFromFirebaseUser(FirebaseUser user) {
    // ignore: unnecessary_null_comparison
    return user != null ? MUser(uid: user.uid) : null;
  }

  Stream<MUser> get user {
    var uid;
    return _auth.authStateChanges().map((event) => MUser(uid: uid));
  }

  /*Future signInAnon<FirebaseUser>(String email, String password) async {
    //    await Firebase.initializeApp();
    try {
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }*/

  /*Future<DocumentSnapshot> getData() async {
              Firebase.initializeApp();
              return await FirebaseFirestore.instance
                  .collection("users")
                  .doc("docID")
                  .get();
            }
          */
  Future registerWithEmailAndPassword(String email, String password) async {
    /*try {
      UserCredential userCredential = (await _auth
          .createUserWithEmailAndPassword(email: email, password: password));
      FirebaseUser user = userCredential.user as FirebaseUser;
      //await DatabaseService(uid: user.uid).updateUserData('0', 'new user', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }*/
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = userCredential.user as FirebaseUser;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    //await FirebaseAuth.instance.signOut();
    _auth.signOut();
    //await auth.signOut();
    /*try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }*/
  }
}

class Auth {
  FirebaseUser? get user => null;
}

class AuthResult {}

class FirebaseUser {
  get uid => null;
}
