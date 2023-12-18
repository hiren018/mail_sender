import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mail_sender/features/authentication/models/user_model.dart';
import 'package:mail_sender/features/authentication/services/auth_datasource.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> appStarted() async {
    try {
      bool isLoggedIn = await FirebaseAuthDataSource().isLoggedIn();

      await Future.delayed(const Duration(seconds: 1));

      if (isLoggedIn) {
        final loggedUser = await FirebaseAuthDataSource().loggedFirebaseUser;
        emit(Authenticated(loggedFirebaseSeller: loggedUser));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<User> loggedIn() async {
    final loggedUser = await FirebaseAuthDataSource().loggedFirebaseUser;
    emit(Authenticated(loggedFirebaseSeller: loggedUser));
    return loggedUser;
  }

  Future<void> loggedOut() async {
    await FirebaseAuthDataSource().logOut();
    emit(Unauthenticated());
  }

  Future<void> resetPassword({required String email}) async {
    await FirebaseAuthDataSource().sendPasswordResetEmail(email: email);
  }

  Future<void> loginWithCredential(String email, String password) async {
    emit(Logging());

    try {
      await FirebaseAuthDataSource().logInWithEmailAndPassword(email, password);
      bool isLoggedIn = await FirebaseAuthDataSource().isLoggedIn();

      if (isLoggedIn) {
        emit(LoginSuccess());
      } else {
        final message = FirebaseAuthDataSource().authException;
        emit(LoginFailure(message: message));
      }
    } catch (e) {
      emit(LoginFailure(message: "Login Failed"));
    }
  }

  Future<void> registerNewUser(
    UserModel newUser,
    String password,
  ) async {
    emit(RegisterLoading());

    try {
      await FirebaseAuthDataSource().signUp(newUser, password);

      bool isLoggedIn = await FirebaseAuthDataSource().isLoggedIn();

      if (isLoggedIn) {
        emit(RegisterSuccess());
      } else {
        final message = FirebaseAuthDataSource().authException;
        emit(RegisterFailure(message: message));
      }
    } catch (e) {
      emit(RegisterFailure(message: "Failed to Register"));
    }
  }
}
