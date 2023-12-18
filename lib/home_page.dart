import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mail_sender/constant.dart';
import 'package:mail_sender/features/sendmail/cubit/pickfile_cubit.dart';
import 'package:mail_sender/features/sendmail/cubit/sendmail_cubit.dart';
import 'package:mail_sender/features/sendmail/ui/drawers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'features/sendmail/ui/send_mail_form.dart';
import 'package:card_swiper/card_swiper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> images = [
    'assets/images/banner1.jpeg',
    'assets/images/banner2.jpeg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
                color: Colors.white,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.account_circle,
                  size: 35,
                ));
          }),
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: const Text('Welcome'),
        ),
        body: Container(
            color: Colors.white38,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Swiper(
                        itemHeight: 100,
                        duration: 500,
                        itemWidth: double.infinity,
                        pagination: const SwiperPagination(),
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Image.asset(
                          images[index],
                          fit: BoxFit.fill,
                        ),
                        autoplay: true,
                        viewportFraction: 1.0,
                        scale: 0.9,
                      ),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Features',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            customButton(
                                title: 'Business Bulk Mail',
                                subTitle:
                                    "Send bulk emails to multiple recipients from your business email using an excel sheet",
                                imgPath: 'assets/images/bulkmail.png',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return MultiBlocProvider(
                                        providers: [
                                          BlocProvider<SendMailCubit>(
                                            create: (context) =>
                                                SendMailCubit(),
                                          ),
                                          BlocProvider<PickFileCubit>(
                                            create: (context) =>
                                                PickFileCubit(),
                                          )
                                        ],
                                        child: SendMailForm(),
                                      );
                                    }),
                                  );
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            customButton(
                                title: 'Personal Bulk Mail',
                                subTitle:
                                    'Send bulk emails to multiple recipients from your personal email using an excel sheet',
                                imgPath: 'assets/images/bulkmail.png',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return MultiBlocProvider(
                                        providers: [
                                          BlocProvider<SendMailCubit>(
                                            create: (context) =>
                                                SendMailCubit(),
                                          ),
                                          BlocProvider<PickFileCubit>(
                                            create: (context) =>
                                                PickFileCubit(),
                                          )
                                        ],
                                        child: SendMailForm(
                                            usingPersonalMail: true),
                                      );
                                    }),
                                  );
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            customButton(
                                isComingSoon: true,
                                title: 'Bulk Messages',
                                subTitle: 'Send bulk messages to whatsApp',
                                imgPath: 'assets/images/whatsappIcon.png',
                                onPressed: () {}),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
        drawer: const Drawers());
  }

  Widget customButton(
      {bool isComingSoon = false,
      String title = "",
      String subTitle = "",
      String imgPath = "",
      onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color:
              kSecondaryColor, // Change this to your desired background color
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Adjust the shadow offset as needed
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            isComingSoon
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kRedColor, // Change this to your desired color
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Container(
              padding: isComingSoon
                  ? EdgeInsets.fromLTRB(16, 0, 16, 16)
                  : EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      imgPath,
                      height: 30,
                      width: 30,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: kPrimaryColor),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          subTitle,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
