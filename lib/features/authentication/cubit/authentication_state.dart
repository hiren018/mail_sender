part of 'authentication_cubit.dart';

abstract class AuthenticationState {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User loggedFirebaseSeller;

  const Authenticated({required this.loggedFirebaseSeller});

  @override
  String toString() {
    return 'Authenticated{email: ${loggedFirebaseSeller.email}}';
  }
}

class Unauthenticated extends AuthenticationState {}

abstract class LoginState extends AuthenticationState {
  const LoginState();
}

abstract class RegisterState extends AuthenticationState {
  const RegisterState();
}

class LoginInitial extends LoginState {}

class Logging extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});

  List<Object> get props => [message];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure({required this.message});

  List<Object> get props => [message];
}
