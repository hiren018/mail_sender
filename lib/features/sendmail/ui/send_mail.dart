import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mail_sender/constant.dart';
import 'package:mail_sender/dialog.dart';
import 'package:mail_sender/features/authentication/cubit/authentication_cubit.dart';
import 'package:mail_sender/features/sendmail/cubit/pickfile_cubit.dart';
import 'package:mail_sender/features/sendmail/cubit/sendmail_cubit.dart';
import 'package:mail_sender/features/sendmail/ui/send_mail_form.dart';
import 'package:mail_sender/home_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SendMail extends StatefulWidget {
  final List<String> emailList;
  final String timer;
  final String subject;
  final String body;

  const SendMail(
      {Key? key,
      required this.subject,
      required this.body,
      required this.emailList,
      required this.timer})
      : super(
          key: key,
        );

  @override
  State<SendMail> createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  var sentTo = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text('Sending emails'),
      ),
      body: BlocListener<SendMailCubit, SendMailState>(
        listener: (context, state) {
          if (state is SendingMail) {
            sentTo = state.sentCount;
          } else if (state is SendEmailFailure) {
            showToast(context, state.error);
          }
        },
        child: BlocBuilder<SendMailCubit, SendMailState>(
          builder: (context, state) {
            if (state is SendMailInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            } else if (state is SendingMail) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 120,
                      lineWidth: 18,
                      animation: true,
                      percent: sentTo.toDouble() / widget.emailList.length,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sent ${sentTo.toString()}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'of ${widget.emailList.length.toString()}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      backgroundColor: Color.fromARGB(255, 198, 211, 225),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: kPrimaryColor,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Sending in progress...',
                      style: TextStyle(fontSize: 18, color: kPrimaryColor),
                    ),
                  ],
                ),
              );
            } else if (state is SendEmailSuccess) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: kGreenColor,
                      size: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Process Completed',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Mail sent successfully',
                        style: TextStyle(color: kPrimaryColor, fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(120, 30)),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor)),
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return MultiBlocProvider(providers: [
                                BlocProvider<AuthenticationCubit>(
                                  create: (context) => AuthenticationCubit(),
                                ),
                                BlocProvider<SendMailCubit>(
                                  create: (context) => SendMailCubit(),
                                ),
                                BlocProvider<PickFileCubit>(
                                    create: (context) => PickFileCubit()),
                              ], child: HomePage());
                            },
                          ), (Route<dynamic> route) => false);
                        },
                        child: const Text(
                          "OKAY",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is SmtpClientFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        'Please check all inputs and Try again later!!',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(120, 30)),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor)),
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(context,
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
                          ), (Route<dynamic> route) => false);
                        },
                        child: const Text(
                          "OKAY",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
