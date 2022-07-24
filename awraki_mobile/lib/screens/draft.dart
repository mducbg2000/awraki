import 'package:awraki_poc/screens/create_document.dart';
import 'package:awraki_poc/services/awraki_service.dart';
import 'package:awraki_poc/shared.dart';
import 'package:awraki_poc/widgets/menu.dart';
import 'package:flutter/material.dart';

import '../models/document.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({Key? key}) : super(key: key);

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  List<Document> drafts = [];

  @override
  void initState() {
    super.initState();
    getDraftDocuments(Shared.keystore.address).then((docs) {
      setState(() {
        drafts = docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draft Documents"),
      ),
      drawer: menu(context),
      body: DataTable(
        columnSpacing: 25,
        dividerThickness: 1,
        columns: const [
          DataColumn(
            label: Text("Subject"),
          ),
          DataColumn(
            label: Text("File name"),
          ),
          DataColumn(
            label: Text("Signers"),
          ),
          DataColumn(
            label: Text(""),
          ),
        ],
        rows: drafts.map((doc) => _draftDoc(doc)).toList(),
      ),
    );
  }

  DataRow _draftDoc(Document doc) => DataRow(
        cells: [
          DataCell(
            Text(doc.subject!),
          ),
          DataCell(
            SizedBox(
              child: Text(doc.filename!, overflow: TextOverflow.ellipsis),
              width: 80,
            ),
          ),
          DataCell(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: doc.partiesAddresses
                  .map(
                    (p) => SizedBox(
                        child: Text(
                          p,
                          overflow: TextOverflow.ellipsis,
                        ),
                        width: 60),
                  )
                  .toList(),
            ),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateDocumentScreen(document: doc),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.yellow,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    deleteDocument(doc.id!);
                    getDraftDocuments(Shared.keystore.address).then((docs) {
                      setState(() {
                        drafts = docs;
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          )
        ],
      );
}
