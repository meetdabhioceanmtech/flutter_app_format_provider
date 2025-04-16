import 'package:flutter_project/data/models/model_response_extend.dart';

class TermsAndConditionsModel extends ModelResponseExtend {
  final bool status;
  final String message;
  final TermsModelData data;

  TermsAndConditionsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: TermsModelData.fromJson(json['data']),
    );
  }
}

class TermsModelData {
  final int id;
  final String title;
  final String description;

  TermsModelData({
    required this.id,
    required this.title,
    required this.description,
  });

  factory TermsModelData.fromJson(Map<String, dynamic> json) {
    return TermsModelData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
