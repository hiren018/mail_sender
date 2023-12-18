import 'package:firebase_auth/firebase_auth.dart';
import 'package:mail_sender/features/authentication/models/user_model.dart';
import 'package:mail_sender/features/authentication/services/firebase_user_datasource.dart';
import 'package:mail_sender/features/authentication/services/secure_storage.dart';

class FirebaseAuthDataSource {
  static final instance = FirebaseAuthDataSource._internal();
  FirebaseAuthDataSource._internal();

  factory FirebaseAuthDataSource() {
    return instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseUserDatasource _userDatasource = FirebaseUserDatasource();
  String _authException = "Authentication Failure";

  String get authException => _authException;

  Future<User> get loggedFirebaseUser async => _firebaseAuth.currentUser!;

  Future<bool> isLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> signUp(UserModel newUser, String password) async {
    try {
      var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: newUser.emailId,
        password: password,
      );
      newUser = newUser.cloneWith(uid: userCredential.user!.uid);

      await _userDatasource.addUserData(newUser);
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  Future<void> logInWithEmailAndPassword(String email, String password) async {
    try {
      var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // final user = await _firebaseAuth.currentUser!;
      // final idToken = await user.getIdToken();
      // print("token1:::${idToken}");

      // SecureStorage().setToken(idToken!);
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut().catchError((error) => print(error));
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _authException = e.message.toString();
    }
  }
}
