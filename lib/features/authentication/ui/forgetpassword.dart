import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mail_sender/constant.dart';
import 'package:mail_sender/dialog.dart';
import 'package:mail_sender/features/authentication/services/auth_datasource.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formkey = GlobalKey<FormState>();

  late String _email;
  final emailValidator = MultiValidator([
    RequiredValidator(
      errorText: 'email is required',
    ),
    EmailValidator(
      errorText: "enter a valid email address",
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Text(
              "Please enter your email and we will send you a link to return to your account",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
            child: Form(
              key: _formkey,
              child: TextFormField(
                onSaved: (input) => _email = input!,
                textInputAction: TextInputAction.next,
                validator: emailValidator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  ),
                  labelText: "Email",
                  hintText: 'Enter your Email',
                  labelStyle: TextStyle(color: kPrimaryColor),
                  suffixIcon: Icon(Icons.email_outlined, color: kPrimaryColor),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor, primary: Colors.white),
                  child: const Text(
                    "Send Request",
                  ),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      await FirebaseAuthDataSource()
                          .sendPasswordResetEmail(email: _email)
                          .then((value) {
                        UtilDialog.showInformation(context,
                            title: 'Request send !!',
                            content:
                                'We have sent a link to your mail id to reset password.');
                      });
                    }
                  })),
        ],
      ),
    );
  }
}
