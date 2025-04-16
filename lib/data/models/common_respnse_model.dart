// ignore_for_file: annotate_overrides

import 'package:flutter_project/data/models/model_response_extend.dart';

class CommonResponseModel extends ModelResponseExtend {
  final bool status;
  final String message;
  final Map<String, dynamic> data;

  CommonResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );
}
