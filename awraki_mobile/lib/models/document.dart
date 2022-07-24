import 'dart:core';

class Document {
  String? id;
  String? subject;
  String? filename;
  bool? isDraft;
  String? contentBase64;
  String? ownerAddress;
  String? state;
  List<String> partiesAddresses = [];

  Document();

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "isDraft": isDraft,
        "filename": filename,
        "contentBase64": contentBase64,
        "ownerAddress": ownerAddress,
        "partiesAddresses": partiesAddresses
      };

  Document.fromJson(Map<String, dynamic> json)
      : id = json['_id'] ?? '',
        subject = json['subject'] ?? '',
        filename = json['filename'] ?? '',
        isDraft = json['isDraft'],
        contentBase64 = json['contentBase64'],
        ownerAddress = json['owner'],
        state = json['state'] ?? '',
        partiesAddresses =
            json['parties'] != null ? json['parties'].cast<String>() : [];
}
