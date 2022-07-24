import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:tezart/tezart.dart';

import '../models/signature_info.dart';
import '../shared.dart';

Future<List<SignatureInfo>> verify(String fileHash) async {
  final response = await Dio().get("${Shared.contractStorage}/$fileHash");
  return (response.data['value'] as List)
      .map((e) => SignatureInfo.fromJson(e))
      .toList();
}

String computeSignature(Keystore keystore, Uint8List content) {
  return Signature.fromBytes(bytes: content, keystore: keystore).edsig;
}
