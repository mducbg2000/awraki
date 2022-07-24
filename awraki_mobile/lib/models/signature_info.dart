class SignatureInfo {
  final String signer;
  final String timestamp;
  final String signature;

  const SignatureInfo(
      {required this.signer, required this.timestamp, required this.signature});

  factory SignatureInfo.fromJson(Map<String, dynamic> json) {
    return SignatureInfo(
        signer: json['signer'],
        timestamp: json['timestamp'],
        signature: json['signature']);
  }
}
