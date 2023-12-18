import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:mail_sender/constant.dart';
import 'package:mail_sender/features/authentication/cubit/authentication_cubit.dart';
import 'package:mail_sender/features/authentication/ui/login.dart';
import 'package:mail_sender/features/sendmail/cubit/pickfile_cubit.dart';
import 'package:mail_sender/features/sendmail/cubit/sendmail_cubit.dart';
import 'package:mail_sender/features/sendmail/ui/send_mail.dart';
import 'package:mailer/mailer.dart';

class SendMailForm extends StatefulWidget {
  final usingPersonalMail;
  SendMailForm({Key? key, this.usingPersonalMail = false}) : super(key: key);

  @override
  State<SendMailForm> createState() => _SendMailFormState();
}

class _SendMailFormState extends State<SendMailForm> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController hostController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController timerController =
      TextEditingController(text: "1");
  final _formKey = GlobalKey<FormState>();

  final subjectValidator = MultiValidator([
    RequiredValidator(
      errorText: "subject is required",
    ),
    MaxLengthValidator(
      100,
      errorText: "subject is too big!",
    ),
  ]);
  final emailValidator = MultiValidator([
    RequiredValidator(
      errorText: 'email is required',
    ),
    EmailValidator(
      errorText: "enter a valid email address",
    ),
  ]);

  final bodyValidator = MultiValidator([
    RequiredValidator(
      errorText: "body of email is required",
    ),
  ]);
  final hostValidator = MultiValidator([
    RequiredValidator(
      errorText: "host is required",
    ),
  ]);
  List<String> _data = [];
  String excelFileText = 'Tap to pick excel file';
  List<Attachment> attechment = [];

  @override
  void dispose() {
    super.dispose();
    bodyController.dispose();
    subjectController.dispose();
    timerController.dispose();
    hostController.dispose();
    emailController.dispose();
    portController.dispose();
    _data = [];
    attechment = [];
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title:
              Text(widget.usingPersonalMail ? "Compose Email" : "Compose Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
          actions: [],
        ),
        body: BlocListener<PickFileCubit, PickFileState>(
          listener: (context, state) async {
            if (state is FilePickError) {
              showToast(context, state.error);
            } else if (state is FilePickSuccess) {
              _data = state.emailList;
              excelFileText = state.fileName;
            } else if (state is PickAttechmentSuccess) {
              attechment = state.fileList!;
            } else if (state is PickAttechmentFailure) {
              showToast(context, state.error);
            }
          },
          child: BlocBuilder<PickFileCubit, PickFileState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: emailController,
                              validator: emailValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Sender email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            widget.usingPersonalMail
                                ? TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: passwordController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter password';
                                      }
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "2FA password of gmail",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: portController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter port number';
                                          }
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: "Port",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        controller: hostController,
                                        validator: hostValidator,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: "Host",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: 20),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: subjectController,
                              validator: subjectValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Subject",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: bodyController,
                                validator: bodyValidator,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Body",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                maxLines: 5),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  await context
                                      .read<PickFileCubit>()
                                      .pickAttechment();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.attachment_outlined),
                                    const SizedBox(width: 10),
                                    const Text('Add an attchments',
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ),
                            if (attechment.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: attechment.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 6,
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              '${attechment[index].fileName}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<PickFileCubit>()
                                                .removeAttechment(
                                                    attechment,
                                                    attechment[index]
                                                        .fileName!);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: timerController,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please set timer';
                                      } else if (num.parse(value) < 1) {
                                        return 'Minimum 1 minute is required';
                                      } else if (num.parse(value) > 10) {
                                        return 'Maximum time limit is 10 min';
                                      }
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Timer",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Expanded(
                                  child: Text(
                                    'Minutes',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await context
                                    .read<PickFileCubit>()
                                    .pickExcelFile();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        width: 2, color: Colors.blueGrey)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      color: Colors.blueGrey,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      excelFileText,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(250, 30)),
                                    backgroundColor: MaterialStateProperty.all(
                                        kPrimaryColor)),
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    if (_data.isEmpty) {
                                      showToast(context, 'Email List is empty');
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (BuildContext context) =>
                                                SendMailCubit()
                                                  ..sendEmailToList(_data,
                                                      usingPersonalMail: widget
                                                          .usingPersonalMail,
                                                      port: portController.text
                                                          .trim(),
                                                      host: hostController.text
                                                          .trim(),
                                                      senderEmail:
                                                          emailController.text
                                                              .trim(),
                                                      subject: subjectController.text
                                                          .trim(),
                                                      password: passwordController
                                                          .text,
                                                      body: bodyController.text
                                                          .trim(),
                                                      timer: timerController
                                                          .text
                                                          .trim(),
                                                      emailAttachments:
                                                          attechment),
                                            child: SendMail(
                                                subject: subjectController.text,
                                                body: bodyController.text,
                                                emailList: _data,
                                                timer: timerController.text),
                                          ),
                                        ),
                                      ).then((value) => {
                                            setState(() {
                                              _data = [];
                                              excelFileText =
                                                  'Tap to pick excel file';
                                            })
                                          });
                                    }
                                  }
                                },
                                child: const Text(
                                  "SEND",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  _showLogoutDialog() {
    final authCubit = BlocProvider.of<AuthenticationCubit>(context);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              scrollable: true,
              clipBehavior: Clip.hardEdge,
              insetPadding: const EdgeInsets.all(12.0),
              backgroundColor: const Color.fromARGB(255, 247, 248, 250),
              content: Text(
                'Do you want to log out ?',
                style: headingStyle.copyWith(fontSize: 20),
                maxLines: 2,
              ),
              actions: [
                TextButton(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor, width: 1)),
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 8, bottom: 8),
                    child: const Text(
                      "No",
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                    child: Container(
                      color: kPrimaryColor,
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 8, bottom: 8),
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      await authCubit.loggedOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlocProvider<AuthenticationCubit>(
                            create: (BuildContext context) =>
                                AuthenticationCubit(),
                            child: const Login(),
                          ),
                        ),
                      );
                    }),
              ]);
        });
  }
}
