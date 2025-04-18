import 'package:hive/hive.dart';

class AppLanguageEntity extends HiveObject {
  final int id;
  final String name;
  final String shortCode;

  AppLanguageEntity({required this.id, required this.name, required this.shortCode});

  AppLanguageEntity copyWith({
    int? id,
    String? name,
    String? shortCode,
    int? isDefault,
  }) {
    return AppLanguageEntity(
      id: id ?? this.id,
      shortCode: shortCode ?? this.shortCode,
      name: name ?? this.name,
    );
  }

  factory AppLanguageEntity.fromJson(Map<String, dynamic> json) {
    return AppLanguageEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      shortCode: json['short_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_code': shortCode,
    };
  }
}
