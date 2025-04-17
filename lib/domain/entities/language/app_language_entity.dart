import 'package:hive/hive.dart';
part 'app_language_entity.g.dart';

@HiveType(typeId: 0)
class AppLanguageEntity extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String shortCode;

  @HiveField(3)
  final int isDefault;

  AppLanguageEntity({required this.id, required this.title, required this.shortCode, required this.isDefault});

  AppLanguageEntity copyWith({
    int? id,
    String? title,
    String? shortCode,
    int? isDefault,
  }) {
    return AppLanguageEntity(
        id: id ?? this.id,
        shortCode: shortCode ?? this.shortCode,
        title: title ?? this.title,
        isDefault: isDefault ?? this.isDefault);
  }
}
