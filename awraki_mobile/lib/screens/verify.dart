import 'dart:io';

import 'package:awraki_poc/services/signature_service.dart';
import 'package:awraki_poc/utils/utils.dart';
import 'package:awraki_poc/widgets/menu.dart';
import 'package:convert/convert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' as pointy;

import '../models/signature_info.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String? contentHash;
  String fileName = "";
  List<SignatureInfo> signatures = [];

  void _pickFile() async {
    try {
      final picked = await FilePicker.platform.pickFiles();
      if (picked != null) {
        final file = File(picked.files.first.path!);
        setState(() {
          fileName = picked.files.first.name;
          contentHash = hex.encode(
            pointy.Blake2bDigest().process(
              file.readAsBytesSync(),
            ),
          );
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Document"),
      ),
      drawer: menu(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pickFile();
                    },
                    child: const Text("Pick a file"),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      fileName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  showLoadingDialog(context, "Verifying");
                  final sigs = await verify(contentHash!);
                  if (sigs.isEmpty) showSnackBar(context, "File is unsigned");
                  setState(() {
                    signatures = sigs;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Verify"),
              ),
              ...signatures
                  .map(
                    (s) => Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Signer:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(s.signer),
                          const Text(
                            "Signature:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(s.signature),
                          const Text(
                            "Sign Time:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(s.timestamp),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
