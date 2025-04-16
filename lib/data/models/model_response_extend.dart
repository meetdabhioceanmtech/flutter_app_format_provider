abstract class ModelResponseExtend {
  bool get status;
  String get message;
  dynamic get data;

  ModelResponseExtend();

  ModelResponseExtend.fromJson(Map<String, dynamic> json);
}
