import 'package:hive/hive.dart';
part 'app_language_entity.g.dart';

@HiveType(typeId: 0)
class AppLanguageEntity extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String shortCode;

  @HiveField(3)
  final int isDefault;

  AppLanguageEntity({required this.id, required this.name, required this.shortCode, required this.isDefault});

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
        isDefault: isDefault ?? this.isDefault);
  }

  factory AppLanguageEntity.fromJson(Map<String, dynamic> json) {
    return AppLanguageEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      shortCode: json['short_code'] as String,
      isDefault: json['is_default'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_code': shortCode,
      'is_default': isDefault,
    };
  }
}
