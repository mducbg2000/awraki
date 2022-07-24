import 'dart:typed_data';

import 'package:awraki_poc/services/signature_service.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/digests/blake2b.dart';
import 'package:tezart/tezart.dart';

import '../shared.dart';

Future<bool> checkReveal(Keystore keyStore) async {
  final client = TezartClient(Shared.rpcNode);
  return await client.isKeyRevealed(keyStore.address);
}

Future<void> sign(Keystore keystore, Uint8List content) async {
  final contentHash = Blake2bDigest().process(content);
  final signature = computeSignature(keystore, contentHash);
  final rpcInterface = RpcInterface(Shared.rpcNode);
  final contract = Contract(
    contractAddress: Shared.contractAddress,
    rpcInterface: rpcInterface,
  );

  print(hex.encode(contentHash));
  print(signature);

  final operations = await contract.callOperation(
    entrypoint: "sign",
    params: {
      "content": hex.encode(contentHash),
      "signature": signature,
    },
    source: keystore,
    customFee: 200000,
    customGasLimit: 100,
    customStorageLimit: 1040000,
  );
  // await operations.executeAndMonitor();
}


