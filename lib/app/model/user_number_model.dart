import 'dart:convert';

import 'package:flutter/services.dart';

List<UserNumber> userNumberFromJson(String str) =>
    List<UserNumber>.from(json.decode(str).map((x) => UserNumber.fromJson(x)));

class UserNumber {
  int? dbId;
  DateTime? createdAt;
  String? number;
  String? leadingColor;
  Uint8List? imageUrl;
  String? userName;
  String? origin;
  String? code;
  bool? isSaved;

  UserNumber(
      {this.dbId,
      this.createdAt,
      this.number,
      this.imageUrl,
      this.leadingColor,
      this.origin,
      this.code,
      this.userName,
      this.isSaved});

  factory UserNumber.fromJson(Map<String, dynamic> json) => UserNumber(
        dbId: json["dbId"],
        createdAt: json["CreatedAt"] == null
            ? null
            : DateTime.parse(json["CreatedAt"]),
        number: json["Number"],
        origin: json["CountryOrigin"],
        code: json["CountryCode"],
        imageUrl: json["imageUrl"],
        isSaved: json["isSaved"],
        leadingColor: json["Color"],
      );
}
