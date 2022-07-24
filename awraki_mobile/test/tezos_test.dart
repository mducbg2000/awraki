import 'dart:typed_data';

import 'package:awraki_poc/services/tezos_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tezart/tezart.dart';

void main() {
  test("test sign", () async {
    final mnemonic = [
      "change",
      "travel",
      "obscure",
      "must",
      "awful",
      "sad",
      "endless",
      "decade",
      "weasel",
      "census",
      "weather",
      "blast",
      "dutch",
      "repeat",
      "arctic"
    ].join(" ");

    final keystore = Keystore.fromMnemonic(mnemonic, email: "fetluzig.mzxprbli@teztnets.xyz", password: "uDjxxUyhCt");

    await sign(keystore, Uint8List.fromList("test".codeUnits));
  });

}
