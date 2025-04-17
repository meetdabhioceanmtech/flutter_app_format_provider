// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectorAdapter extends TypeAdapter<Sector> {
  @override
  final int typeId = 4;

  @override
  Sector read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sector(
      id: fields[0] as int,
      title: fields[1] as String,
      shortDescription: fields[2] as String,
      icon: fields[3] as String,
      createdAt: fields[4] as String,
      experiance: (fields[5] as List).cast<UserLanguage>(),
      skill: (fields[6] as List).cast<UserLanguage>(),
    );
  }

  @override
  void write(BinaryWriter writer, Sector obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.shortDescription)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.experiance)
      ..writeByte(6)
      ..write(obj.skill);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserLanguageAdapter extends TypeAdapter<UserLanguage> {
  @override
  final int typeId = 5;

  @override
  UserLanguage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLanguage(
      id: fields[0] as int,
      title: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserLanguage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
