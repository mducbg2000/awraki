import 'package:awraki_poc/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:tezart/tezart.dart';

import '../routes.dart';
import '../shared.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _privateKeyController = TextEditingController();

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              "assets/logo.png",
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: TextFormField(
              controller: _privateKeyController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "Private Key",
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 40),
                ),
                onPressed: () {
                  _login();
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _login() async {
    try {
      showLoadingDialog(context, "Logging in");
      Shared.keystore =
          Keystore.fromSecretKey(_privateKeyController.text.trim());
      Navigator.pushReplacementNamed(context, Routes.document);
    } on Exception catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
