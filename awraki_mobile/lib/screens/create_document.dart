import 'dart:convert';
import 'dart:io';

import 'package:awraki_poc/services/awraki_service.dart';
import 'package:awraki_poc/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/document.dart';
import '../routes.dart';
import '../services/tezos_service.dart';
import '../shared.dart';

class CreateDocumentScreen extends StatefulWidget {
  final Document? document;

  const CreateDocumentScreen({Key? key, this.document}) : super(key: key);

  @override
  State<CreateDocumentScreen> createState() => _CreateDocumentScreenState();
}

class _CreateDocumentScreenState extends State<CreateDocumentScreen> {
  final subjectController = TextEditingController();
  final addressController = TextEditingController();
  String filename = "";
  List<String> partiesAddresses = [];
  late Document document;

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      document = widget.document!;
      subjectController.text = document.subject ?? '';
      partiesAddresses = document.partiesAddresses;
      filename = document.filename ?? "";
    } else {
      partiesAddresses = [Shared.keystore.address];
      document = Document()
        ..ownerAddress = Shared.keystore.address
        ..partiesAddresses = partiesAddresses;
    }
  }

  void _pickFile() async {
    try {
      final picked = await FilePicker.platform.pickFiles();
      if (picked != null) {
        final file = File(picked.files.first.path!);
        final content = base64Encode(file.readAsBytesSync());
        document.contentBase64 = content;
        document.filename = picked.files.first.name;
        setState(() {
          filename = document.filename!;
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
        title: Text(document.id == null ? "Create document" : "Edit document"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: subjectController,
                      onChanged: (subject) {
                        document.subject = subject;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(1),
                        labelText: "Subject",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _pickFile();
                          },
                          child: const Text("Upload file"),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            filename,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Party's addresses",
                          style: TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          color: Colors.blue,
                          onPressed: () {
                            _showAddAddress();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final isOwner =
                            partiesAddresses[index] == Shared.keystore.address;
                        return SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                partiesAddresses[index],
                                overflow: TextOverflow.ellipsis,
                              ),
                              isOwner ? const Text("(you)") : const Text(""),
                              IconButton(
                                onPressed: isOwner
                                    ? null
                                    : () {
                                        setState(
                                          () {
                                            partiesAddresses = partiesAddresses
                                              ..removeAt(index);
                                          },
                                        );
                                        document.partiesAddresses =
                                            partiesAddresses;
                                      },
                                icon: Icon(
                                  Icons.delete,
                                  color: isOwner ? Colors.grey : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: partiesAddresses.length,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      showLoadingDialog(context, "Signing");
                      if (document.subject == null ||
                          document.subject!.isEmpty) {
                        throw Exception("Subject must not be empty!");
                      }
                      document.isDraft = false;

                      if (document.id == null) {
                        if (document.contentBase64 == null) {
                          throw Exception("Select file to sign!");
                        }
                        await sign(Shared.keystore,
                            base64Decode(document.contentBase64!));
                        await createDocument(document);
                      } else {
                        document.contentBase64 ??=
                            await getContent(document.id!);
                        await sign(Shared.keystore,
                            base64Decode(document.contentBase64!));
                        await updateDocument(document.id!, document);
                      }
                      Navigator.pushReplacementNamed(context,
                          document.id == null ? Routes.document : Routes.draft);
                    } catch (e) {
                      showSnackBar(context, "Fail to sign!");
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Submit and sign"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () async {
                    try {
                      showLoadingDialog(context, "Updating");
                      document.isDraft = true;
                      if (document.id == null) {
                        await createDocument(document);
                      } else {
                        document.contentBase64 ??=
                            await getContent(document.id!);
                        await updateDocument(document.id!, document);
                      }
                      Navigator.pushReplacementNamed(context,
                          document.id == null ? Routes.document : Routes.draft);
                    } catch (e) {
                      print(e);
                      showSnackBar(context, "Fail to update");
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save as draft"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showAddAddress() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add address"),
        content: TextField(
          controller: addressController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              setState(() {
                partiesAddresses = [
                  ...partiesAddresses,
                  addressController.text
                ];
              });
              document.partiesAddresses = partiesAddresses;
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
