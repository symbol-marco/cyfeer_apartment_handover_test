import 'package:flutter/cupertino.dart';

class AppRouter {
  static Future pushPage(BuildContext context, Widget page) => Navigator.push(
        context,
        CupertinoPageRoute(builder: (BuildContext context) => page),
      );

  static Future pushPageDialog(BuildContext context, Widget page) =>
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) => page,
          fullscreenDialog: true,
        ),
      );

  static Future replacePage(BuildContext context, Widget page) =>
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (BuildContext context) => page));
}
