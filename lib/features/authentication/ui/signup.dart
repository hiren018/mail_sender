import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mail_sender/constant.dart';
import 'package:mail_sender/dialog.dart';
import 'package:mail_sender/features/authentication/cubit/authentication_cubit.dart';
import 'package:mail_sender/features/authentication/models/user_model.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isShowPassword = false;
  bool isShowConfirmPassword = false;
  final _formkey = GlobalKey<FormState>();
  late String email;
  late String name;
  late String mobileNo;
  String passwd = "", finalPasswd = "";

  @override
  Widget build(BuildContext context) {
    final emailValidator = MultiValidator([
      RequiredValidator(
        errorText: 'email is required',
      ),
      EmailValidator(
        errorText: "enter a valid email address",
      ),
    ]);
    final nameValidator = MultiValidator([
      RequiredValidator(
        errorText: 'name is required',
      ),
    ]);
    final mobileValidator = MultiValidator([
      RequiredValidator(
        errorText: 'mobile number is required',
      ),
      MaxLengthValidator(10, errorText: 'Enter 10 digit mobile number'),
      MinLengthValidator(10, errorText: 'Enter 10 digit mobile number'),
    ]);
    final passwordValidator = MultiValidator([
      RequiredValidator(
        errorText: 'password is required',
      ),
      MinLengthValidator(
        6,
        errorText: 'password must be at least 6 digits long',
      ),
      PatternValidator(
        r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character',
      ),
    ]);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('Signup'),
          centerTitle: false,
        ),
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              UtilDialog.showWaiting(context);
            }

            if (state is RegisterSuccess) {
              UtilDialog.hideWaiting(context);
              BlocProvider.of<AuthenticationCubit>(context).loggedIn();
              UtilDialog.showInformation(
                context,
                title: 'Success !!',
                content:
                    'Your account is created. login with credential to continue',
                onClose: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider<AuthenticationCubit>(
                          create: (context) => AuthenticationCubit(),
                          child: Login(),
                        );
                      },
                    ),
                  );
                },
              );
            }
            if (state is RegisterFailure) {
              UtilDialog.hideWaiting(context);
              UtilDialog.showInformation(context, content: state.message);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          onSaved: (input) => name = input!,
                          textInputAction: TextInputAction.next,
                          validator: nameValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            labelText: "Name",
                            hintText: 'Enter your name',
                            labelStyle: TextStyle(color: kPrimaryColor),
                            suffixIcon: Icon(Icons.person_outline,
                                color: kPrimaryColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          onSaved: (input) => mobileNo = input!,
                          textInputAction: TextInputAction.next,
                          validator: mobileValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            labelText: "Mobile",
                            hintText: 'Enter your mobile number',
                            labelStyle: TextStyle(color: kPrimaryColor),
                            suffixIcon:
                                Icon(Icons.phone_android, color: kPrimaryColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          onSaved: (input) => email = input!,
                          textInputAction: TextInputAction.next,
                          validator: emailValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          onChanged: (val) => passwd = val,
                          onSaved: (input) => passwd = input!,
                          textInputAction: TextInputAction.go,
                          validator: passwordValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.text,
                          obscureText: !isShowPassword,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            hintText: 'Enter your Password',
                            labelText: "Password",
                            labelStyle: const TextStyle(color: kPrimaryColor),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: IconButton(
                              color: kPrimaryColor,
                              icon: isShowPassword
                                  ? Icon(Icons.visibility_outlined)
                                  : Icon(Icons.visibility_off_outlined),
                              splashRadius: 15,
                              onPressed: () {
                                setState(
                                    () => isShowPassword = !isShowPassword);
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          onSaved: (input) => finalPasswd = input!,
                          validator: (val) => MatchValidator(
                                  errorText: 'passwords do not match')
                              .validateMatch(val!, passwd),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.text,
                          obscureText: !isShowConfirmPassword,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            hintText: 'Re-enter your password',
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: kPrimaryColor),
                            suffixIcon: IconButton(
                              color: kPrimaryColor,
                              icon: isShowConfirmPassword
                                  ? Icon(Icons.visibility_outlined)
                                  : Icon(Icons.visibility_off_outlined),
                              splashRadius: 15,
                              onPressed: () {
                                setState(() => isShowConfirmPassword =
                                    !isShowConfirmPassword);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 100,
                        height: 35,
                        child: TextButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              _formkey.currentState!.save();

                              UserModel newUser = UserModel(
                                  uid: '',
                                  emailId: email.trim(),
                                  userName: name.trim(),
                                  paymentStatus: Status.pending,
                                  mobileNo: mobileNo.trim(),
                                  subscriptionType: SubscriptionType.silver,
                                  createdAt: DateTime.now(),
                                  subscriptionEndDate: DateTime.now(),
                                  subscriptionStartDate: DateTime.now());
                              BlocProvider.of<AuthenticationCubit>(context)
                                  .registerNewUser(
                                newUser,
                                passwd.trim(),
                              );
                            }
                          },
                          child: const Text('SignUp'),
                          style: TextButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              primary: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
