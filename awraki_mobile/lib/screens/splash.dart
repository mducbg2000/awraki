import 'package:awraki_poc/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            width: 300,
            height: 300,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: 80,
          ),
          const SpinKitCircle(
            color: Colors.blue,
            size: 100,
          )
        ],
      ),
    );
  }

  _navigate() async {
    Navigator.pushReplacementNamed(context, Routes.login);
  }
}
