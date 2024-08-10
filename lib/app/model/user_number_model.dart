import 'dart:convert';

List<UserNumber> userNumberFromJson(String str) =>
    List<UserNumber>.from(json.decode(str).map((x) => UserNumber.fromJson(x)));

class UserNumber {
  int? dbId;
  DateTime? createdAt;
  String? number;

  UserNumber({
    this.dbId,
    this.createdAt,
    this.number,
  });

  factory UserNumber.fromJson(Map<String, dynamic> json) => UserNumber(
    dbId: json["dbId"],
    createdAt: json["CreatedAt"] == null
        ? null
        : DateTime.parse(json["CreatedAt"]),
    number: json["Number"],
  );
}