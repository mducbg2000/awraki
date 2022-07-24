import 'dart:convert';
import 'dart:io';

import 'package:awraki_poc/services/awraki_service.dart';
import 'package:awraki_poc/utils/utils.dart';
import 'package:awraki_poc/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:tezart/tezart.dart';

import '../models/document.dart';
import '../routes.dart';
import '../services/tezos_service.dart';
import '../shared.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({Key? key}) : super(key: key);

  @override
  _DocumentScreenState createState() {
    return _DocumentScreenState();
  }
}

class _DocumentScreenState extends State<DocumentScreen> {
  String? fileName;
  final Keystore keystore = Shared.keystore;
  String stateFilter = 'All';

  List<Document> allDocuments = [];
  List<Document> filteredDocs = [];

  _loadDoc() {
    getDocumentsBySigner(keystore.address).then((docs) {
      setState(() {
        allDocuments = docs;
        filteredDocs = docs;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
      ),
      drawer: menu(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterBtn(),
          _listDocument(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.createDocument);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _filterBtn() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: DropdownButton(
          value: stateFilter,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.blue),
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          items: ['All', 'Signed', 'Pending'].map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          onChanged: (String? newState) {
            setState(
              () {
                stateFilter = newState!;
                filteredDocs = allDocuments
                    .where((e) =>
                        newState == 'All' ||
                        e.state?.toLowerCase() == newState.toLowerCase())
                    .toList();
              },
            );
          },
        ),
      );

  _listDocument() => DataTable(
        dividerThickness: 1,
        columnSpacing: 25,
        columns: const [
          DataColumn(
            label: Text("Subject"),
          ),
          DataColumn(
            label: Text("Owner"),
          ),
          DataColumn(
            label: Text("State"),
          ),
          DataColumn(
            label: Text(""),
          ),
        ],
        rows: filteredDocs.map((doc) => _document(doc)).toList(),
      );

  DataRow _document(Document doc) => DataRow(
        cells: [
          DataCell(
            Text(doc.subject!),
          ),
          DataCell(
            SizedBox(
              child: Text(
                doc.ownerAddress!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              width: 80,
            ),
          ),
          DataCell(
            Text(doc.state ?? ''),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    try {
                      final contentBase64 = await getContent(doc.id!);
                      File("/storage/emulated/0/Download/${doc.filename}")
                          .writeAsBytesSync(base64Decode(contentBase64));
                      showSnackBar(context, "Download successful!");
                    } catch (e) {
                      print(e);
                      showSnackBar(context, "Cannot download file!");
                    }
                  },
                  icon: const Icon(Icons.download, color: Colors.blue),
                ),
                IconButton(
                  onPressed: doc.state?.toLowerCase() == "SIGNED".toLowerCase()
                      ? null
                      : () async {
                          try {
                            final contentBase64 = await getContent(doc.id!);
                            await sign(
                                Shared.keystore, base64Decode(contentBase64));
                            await partySignDocument(
                                doc.id!, Shared.keystore.address);
                            showSnackBar(context, "Sign successful!");
                            _loadDoc();
                          } catch (e) {
                            print(e);
                            showSnackBar(context, "Fail to sign!");
                          }
                        },
                  icon: Icon(Icons.done,
                      color: doc.state?.toLowerCase() == "SIGNED".toLowerCase()
                          ? Colors.grey
                          : Colors.green),
                ),
              ],
            ),
          )
        ],
      );
}
