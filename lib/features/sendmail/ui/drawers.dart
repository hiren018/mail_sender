import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mail_sender/constant.dart';
import 'package:mail_sender/features/authentication/cubit/authentication_cubit.dart';
import 'package:mail_sender/features/authentication/ui/login.dart';
import 'package:mail_sender/features/sendmail/ui/aboutUs.dart';
import 'package:mail_sender/features/sendmail/ui/myAcount.dart';

class Drawers extends StatefulWidget {
  const Drawers({Key? key}) : super(key: key);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  int tapindex = 10;

  String _appVersion = '1.0.0'; // Default value for app version

  @override
  void initState() {
    super.initState();
    // _fetchAppVersion();
  }

  Future<void> _fetchAppVersion() async {
    // setState(() {
    //   _appVersion = packageInfo.version;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final List title = ['My account', 'About us'];
    List iconlist = [
      Icons.account_box,
      Icons.group,
    ];

    _onTapofItem(String item) async {
      switch (item) {
        case 'My account':
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    //  MultiBlocProvider(
                    //   providers: [
                    // BlocProvider(
                    //   create: (context) => OrderCubit(),
                    // ),
                    // BlocProvider<InternetCubit>(
                    //   create: (context) => InternetCubit(),
                    // ),
                    // ],
                    // child:
                    MyAccountPage(),
                // ),
              ),
              (route) => true);
          break;
        case 'About us':
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AboutUsPage()),
              (route) => true);
          break;
        case 'Logout':
          _showLogoutDialog();
          break;
        default:
      }
    }

    return SafeArea(
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  CircleAvatar(
                      radius: 35,
                      backgroundColor: kPrimaryColor,
                      child: Text(
                        'A',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      )),
                  Text(
                    'Adzone Web',
                    style: TextStyle(
                        fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: title.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          color:
                              tapindex == index ? kPrimaryColor : Colors.white,
                        ),
                        child: ListTile(
                          leading: Icon(
                            iconlist[index],
                            color:
                                tapindex == index ? Colors.white : Colors.black,
                          ),
                          title: Text(
                            title[index],
                            style: TextStyle(
                              color: tapindex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              tapindex = index;
                            });
                            _onTapofItem(title[index]);
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(22),
                          child: ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              _onTapofItem('Logout');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Version',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    _appVersion,
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
    );
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
