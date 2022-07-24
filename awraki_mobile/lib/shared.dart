import 'package:dio/dio.dart';
import 'package:tezart/tezart.dart';

class Shared {
  // tezos
  static const rpcNode = "https://jakartanet.smartpy.io/";
  static const contractAddress = "KT1TPBagpwY6HFdanPCAhcMuxGHzry7pAr9f";
  static const contractStorage =
      "https://api.jakartanet.tzkt.io/v1/bigmaps/52174/keys";

  static late Keystore keystore;

  // account
  static const dukePrivate = "edskRe3gRhDuMNZQgyruPSESayRL9wtTt9A9Z5nRfxCiiChxDnbzxASAqQnC9yRxdnurq9KEo1ik5JwzHR7BmiYdjBLVvquyuJ";
  static const elisePrivate = "edskRhirLJFw9d57v8sFU3QgFSLcFu8zmncxSCY1pWvLUtnSARXamyGtizKNLgTkZS3EfaJ8Qm27vHL9yRDvPSafoiFewt7bvq";

  static const dukeAddress = "tz1SmcFXgH3YDcEkuzZ5W2Ww8Ujk6EV6AtUB";
  static const eliseAddress = "tz1SCb6W33GWZBKUeYnsrbCmBxApbtpB1uWw";

  // awraki server
  static const serverAddress = "http://10.0.2.2";
  static const awrakiServer = "$serverAddress:3001";

  static final dio = Dio(
    BaseOptions(
      baseUrl: awrakiServer,
    ),
  );
}
