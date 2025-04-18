// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter_project/data/models/common_model/model_response_extend.dart';
import 'package:flutter_project/domain/entities/language/app_language_entity.dart';

class LanguageModel extends ModelResponseExtend {
  final bool status;
  final String message;
  final List<AppLanguageEntity>? data;

  LanguageModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      status: json["status"] ?? false,
      message: json["message"].toString(),
      data: json["data"] != null && json["data"]["language"] != null
          ? List<LanguageDetailModel>.from(json["data"]["language"].map((x) => LanguageDetailModel.fromJson(x)))
          : null,
    );
  }
}

class LanguageDetailModel extends AppLanguageEntity {
  final int id;
  final String name;
  final String shortCode;
  final int isDefault;

  LanguageDetailModel({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.isDefault,
  }) : super(
          id: id,
          name: name,
          shortCode: shortCode,
          isDefault: isDefault,
        );

  factory LanguageDetailModel.fromJson(Map<String, dynamic> json) => LanguageDetailModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        name: json["title"]?.toString() ?? 'English',
        shortCode: json["iso_code"]?.toString() ?? 'en',
        isDefault: 0,
      );
}
