import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kPrimaryColor = Color.fromARGB(255, 20, 72, 132);
const kPrimaryLightColor = Color.fromARGB(255, 80, 122, 162);
const kBackgroundColor = Color.fromARGB(255, 255, 255, 255);
const kGreenColor = Color.fromARGB(255, 39, 121, 42);
const kRedColor = Color.fromARGB(255, 205, 31, 31);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Colors.deepPurpleAccent, Color(0xFF80CBC4)],
);
const kSecondaryColor = Color(0xFFE3F2FD);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    overflow: TextOverflow.ellipsis);

const normalText1 = TextStyle(
  fontSize: 20,
  color: Colors.black,
);

Widget loader() {
  return const CircularProgressIndicator(
    color: kPrimaryColor,
  );
}

showToast(BuildContext context, String text) {
  Fluttertoast.showToast(msg: text, backgroundColor: kPrimaryLightColor);
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

String firstLetterCap(String str) {
  str = str.splitMapJoin(
    RegExp(r'\w+'),
    onMatch: (m) =>
        m.group(0)!.substring(0, 1).toUpperCase() +
        m.group(0)!.substring(1).toLowerCase(),
    onNonMatch: (n) => ' ',
  );
  return str;
}
