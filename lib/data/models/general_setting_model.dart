// ignore_for_file: annotate_overrides, overridden_fields

import 'package:hive/hive.dart';
import 'package:flutter_project/data/models/model_response_extend.dart';
import 'package:flutter_project/domain/entities/general_setting/general_setting_entity.dart';
part 'general_setting_model.g.dart';

class GeneralSettingModel extends ModelResponseExtend {
  bool status;
  String message;
  GeneralSettinData? data;

  GeneralSettingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GeneralSettingModel.fromJson(Map<String, dynamic> json) => GeneralSettingModel(
        status: json["status"],
        message: json["message"]?.toString() ?? '',
        data: json["data"] == null ? null : GeneralSettinData.fromJson(json["data"]),
      );
}

class GeneralSettinData extends GeneralSettingEntity {
  final List<Sector> sectors;
  final List<UserLanguage> yearOfExperiance;
  final List<UserLanguage> userLanguages;
  final String mobileNumber;
  final String email;
  final String supportingTiming;
  final List<String> positionfor;
  final String path;

  const GeneralSettinData({
    required this.sectors,
    required this.yearOfExperiance,
    required this.userLanguages,
    required this.mobileNumber,
    required this.email,
    required this.supportingTiming,
    required this.positionfor,
    required this.path,
  }) : super(
          sectors: sectors,
          yearOfExperiance: yearOfExperiance,
          userLanguages: userLanguages,
          mobileNumber: mobileNumber,
          email: email,
          supportingTiming: supportingTiming,
          positionfor: positionfor,
          basePath: path,
        );

  factory GeneralSettinData.fromJson(Map<String, dynamic> json) => GeneralSettinData(
        mobileNumber: json["mobile_no"],
        email: json["email"],
        supportingTiming: json["support_timing"],
        sectors: json["sectors"] == null ? [] : List<Sector>.from(json["sectors"].map((x) => Sector.fromJson(x))),
        yearOfExperiance: json["year_of_experiance"] == null
            ? []
            : List<UserLanguage>.from(json["year_of_experiance"].map((x) => UserLanguage.fromJson(x))),
        userLanguages: json["user_languages"] == null
            ? []
            : List<UserLanguage>.from(json["user_languages"].map((x) => UserLanguage.fromJson(x))),
        positionfor: json["position_for"] == null ? [] : List<String>.from(json["position_for"]),
        path: json["path"]?.toString() ?? "",
      );
}

@HiveType(typeId: 4)
class Sector {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String shortDescription;
  @HiveField(3)
  String icon;
  @HiveField(4)
  String createdAt;
  @HiveField(5)
  List<UserLanguage> experiance;
  @HiveField(6)
  List<UserLanguage> skill;

  Sector({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.icon,
    required this.createdAt,
    required this.experiance,
    required this.skill,
  });

  factory Sector.fromJson(Map<String, dynamic> json) => Sector(
        id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
        title: json["title"]?.toString() ?? '',
        shortDescription: json["short_description"]?.toString() ?? '',
        icon: json["icon"]?.toString() ?? '',
        createdAt: json["created_at"].toString(),
        experiance: json["experiance"] == null
            ? []
            : List<UserLanguage>.from(json["experiance"].map((x) => UserLanguage.fromJson(x))),
        skill: json["skill"] == null ? [] : List<UserLanguage>.from(json["skill"].map((x) => UserLanguage.fromJson(x))),
      );
}

@HiveType(typeId: 5)
class UserLanguage {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;

  UserLanguage({
    required this.id,
    required this.title,
  });

  factory UserLanguage.fromJson(Map<String, dynamic> json) => UserLanguage(
        id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
        title: json["title"]?.toString() ?? "",
      );
}
