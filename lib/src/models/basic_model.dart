// To parse this JSON data, do
//
//     final basicModel = basicModelFromJson(jsonString);

import 'dart:convert';

BasicModel basicModelFromJson(String str) =>
    BasicModel.fromJson(json.decode(str));

String basicModelToJson(BasicModel data) => json.encode(data.toJson());

class BasicModel {
  BasicModel({
    this.id,
    required this.paramText,
    required this.paramNum,
    required this.paramBool,
    required this.paramDate,
  });

  int? id;
  String paramText;
  double paramNum;
  bool paramBool;
  String paramDate;

  factory BasicModel.fromJson(Map<String, dynamic> json) => BasicModel(
        id: json["id"],
        paramText: json["paramText"],
        paramNum: json["paramNum"],
        paramBool: json["paramBool"],
        paramDate: json["paramDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paramText": paramText,
        "paramNum": paramNum,
        "paramBool": paramBool,
        "paramDate": paramDate,
      };
}
