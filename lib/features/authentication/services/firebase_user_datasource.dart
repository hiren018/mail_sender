import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mail_sender/features/authentication/models/user_model.dart';

class FirebaseUserDatasource {
  final _userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> addUserData(UserModel newUser) async {
    return await _userCollection
        .doc(newUser.uid)
        .set(newUser.toMap())
        .catchError((error) => print('error in add data :: ${error}'));
  }

  Future<UserModel> getUserById(String uid) async {
    return await _userCollection
        .doc(uid)
        .get()
        .then((doc) => UserModel.fromMap(doc.data()!));
  }

  Future<void> updateUserData(UserModel updatedSeller) async {
    await _userCollection.doc(updatedSeller.uid).get().then((doc) async {
      if (doc.exists) {
        await doc.reference.update(updatedSeller.toMap());
      }
    }).catchError((error) {
      print(error);
    });
  }

  Future<bool> isExistInCollection(String uid) async {
    return await _userCollection.doc(uid).get().then((doc) {
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    });
  }
}
