import 'package:flutter/material.dart';
import 'package:qr_scanner/scaner.dart';
import 'constants.dart' as constants;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppEnticer(),
    );
  }
}

class AppEnticer extends StatefulWidget {
  const AppEnticer({Key? key}) : super(key: key);

  @override
  _AppEnticerState createState() => _AppEnticerState();
}

class _AppEnticerState extends State<AppEnticer> {
  bool expanded = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        expanded = true;
      });

      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Scaner()),
            (route) => false);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(constants.mainColor),
        ),
        Align(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: expanded ? 1.0 : 0.0,
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                color: Color(constants.whiteColor),
              ),
            ),
          ),
          alignment: Alignment.bottomCenter,
        ),
      ],
    );
  }
}
