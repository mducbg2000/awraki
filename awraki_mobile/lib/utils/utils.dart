import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void showLoadingDialog(BuildContext context, String description) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(description),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SpinKitPouringHourGlass(
              color: Colors.blue,
              size: 50,
            ),
          ],
        ),
      ),
    );

void showSnackBar(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
