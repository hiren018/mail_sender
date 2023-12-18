import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mail_sender/features/authentication/cubit/authentication_cubit.dart';
import 'package:mail_sender/features/authentication/ui/login.dart';
import 'package:mail_sender/features/sendmail/cubit/pickfile_cubit.dart';
import 'package:mail_sender/features/sendmail/cubit/sendmail_cubit.dart';
import 'package:mail_sender/home_page.dart';

enum Environment {
  dev,
  prod,
}

Future<void> mainCommon(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(
      fileName: "${env.name}.env", mergeWith: Platform.environment);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AdZone Web',
        home: SplashPage());
  }
}

class SplashPage extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthenticationCubit>(
                  create: (context) => AuthenticationCubit()..appStarted(),
                ),
                BlocProvider<SendMailCubit>(
                  create: (context) => SendMailCubit(),
                ),
                BlocProvider<PickFileCubit>(
                    create: (context) => PickFileCubit()),
              ],
              child: _firebaseAuth.currentUser == null ? Login() : HomePage(),
            );
          },
        ),
      ),
    );

    return Material(
      child: Center(
          child:
              Image.asset('assets/images/adzone.png', height: 500, width: 250)),
    );
  }
}
