import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
  return false;
}

Future<bool> addCoin(String id, String amount) async {
  // Is the coin added successfully, using firestore transactions
  // Reading values in firestore and adding on to that value
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var value = double.parse(amount);
    // Collections always UppercaseCamelCase
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Coins')
        .doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      // Ex. user wants bitcoin but has never bought bitcoin
      if (!snapshot.exists) {
        documentReference.set({'Amount': value});
        return true;
      }
      double newAmount = value + snapshot.get('Amount');
      transaction.update(documentReference, {'Amount': newAmount});
      return true;
    });
  } catch (e) {
    return false;
  }
  return false;
}

Future<bool> removeCoin(String id) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Coins')
        .doc(id)
        .delete();

    return true;
  } catch (e) {
    return false;
  }
}
