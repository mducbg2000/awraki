import 'package:awraki_poc/shared.dart';
import '../models/document.dart';

createDocument(Document doc) async {
  await Shared.dio.post(
    '/records',
    data: doc.toJson(),
  );
}

updateDocument(String id, Document doc) async {
  await Shared.dio.put(
    '/records/$id',
    data: doc.toJson(),
  );
}

deleteDocument(String id) async {
  await Shared.dio.delete('/records/$id');
}

partySignDocument(String id, String partyAddress) async {
  await Shared.dio.patch('/records/$id', data: {"partyAddress": partyAddress});
}

Future<List<Document>> getDocumentsBySigner(String address) async {
  final res = await Shared.dio.get('/records?signer=$address');
  return (res.data as List).map((json) => Document.fromJson(json)).toList();
}

Future<List<Document>> getDraftDocuments(String owner) async {
  final res = await Shared.dio.get('/records?owner=$owner');
  return (res.data as List)
      .map(
        (json) => Document.fromJson(json),
      )
      .toList();
}

Future<String> getContent(String id) async {
  return (await Shared.dio.get(
    '/records/$id',
  ))
      .data as String;
}
