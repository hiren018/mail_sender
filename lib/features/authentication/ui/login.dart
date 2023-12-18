import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mail_sender/constant.dart';
import 'package:mail_sender/dialog.dart';
import 'package:mail_sender/features/authentication/cubit/authentication_cubit.dart';
import 'package:mail_sender/features/authentication/ui/forgetpassword.dart';
import 'package:mail_sender/features/authentication/ui/signup.dart';
import 'package:mail_sender/features/sendmail/cubit/pickfile_cubit.dart';
import 'package:mail_sender/features/sendmail/cubit/sendmail_cubit.dart';
import 'package:mail_sender/features/sendmail/ui/send_mail_form.dart';
import 'package:mail_sender/home_page.dart';

final auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isShowPassword = false;
  final _formkey = GlobalKey<FormState>();
  late String email, passwd;
  final emailValidator = MultiValidator([
    RequiredValidator(
      errorText: 'email is required',
    ),
    EmailValidator(
      errorText: "enter a valid email address",
    ),
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(
      errorText: 'password is required',
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is Logging) {
          UtilDialog.showWaiting(context);
        }

        if (state is LoginSuccess) {
          UtilDialog.hideWaiting(context);
          BlocProvider.of<AuthenticationCubit>(context).loggedIn();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<AuthenticationCubit>(
                      create: (context) => AuthenticationCubit(),
                    ),
                    BlocProvider<SendMailCubit>(
                      create: (context) => SendMailCubit(),
                    ),
                    BlocProvider<PickFileCubit>(
                        create: (context) => PickFileCubit()),
                  ],
                  child: HomePage(),
                );
              },
            ),
          );
        }
        if (state is LoginFailure) {
          UtilDialog.hideWaiting(context);
          UtilDialog.showInformation(context, content: state.message);
        }
      },
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/adzone.png',
                              height: 200, width: 250),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (input) => email = input!,
                              textInputAction: TextInputAction.next,
                              validator: emailValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                ),
                                labelText: "Email",
                                hintText: 'Enter your Email',
                                labelStyle: TextStyle(color: kPrimaryColor),
                                suffixIcon: Icon(Icons.email_outlined,
                                    color: kPrimaryColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              onSaved: (input) => passwd = input!,
                              textInputAction: TextInputAction.go,
                              validator: passwordValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              obscureText: !isShowPassword,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                ),
                                hintText: 'Enter your Password',
                                labelText: "Password",
                                labelStyle:
                                    const TextStyle(color: kPrimaryColor),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: IconButton(
                                  color: kPrimaryColor,
                                  icon: isShowPassword
                                      ? const Icon(Icons.visibility_outlined)
                                      : const Icon(
                                          Icons.visibility_off_outlined),
                                  splashRadius: 15,
                                  onPressed: () {
                                    setState(
                                        () => isShowPassword = !isShowPassword);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have Account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<AuthenticationCubit>(
                                              create: (context) =>
                                                  AuthenticationCubit(),
                                              child: const Signup(),
                                            )),
                                  );
                                },
                                child: const Text(
                                  'SignUp Now',
                                  style:
                                      const TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 100,
                            height: 35,
                            child: TextButton(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formkey.currentState!.validate()) {
                                  _formkey.currentState!.save();
                                  BlocProvider.of<AuthenticationCubit>(context)
                                      .loginWithCredential(
                                    email.trim(),
                                    passwd.trim(),
                                  );
                                }
                              },
                              child: const Text('Login'),
                              style: TextButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  primary: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPassword()));
                            },
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
