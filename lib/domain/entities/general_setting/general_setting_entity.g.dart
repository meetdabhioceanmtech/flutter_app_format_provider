// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_setting_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneralSettingEntityAdapter extends TypeAdapter<GeneralSettingEntity> {
  @override
  final int typeId = 3;

  @override
  GeneralSettingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeneralSettingEntity(
      sectors: (fields[0] as List).cast<Sector>(),
      yearOfExperiance: (fields[1] as List).cast<UserLanguage>(),
      userLanguages: (fields[2] as List).cast<UserLanguage>(),
      mobileNumber: fields[3] as String,
      email: fields[4] as String,
      supportingTiming: fields[5] as String,
      positionfor: (fields[6] as List).cast<String>(),
      basePath: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeneralSettingEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.sectors)
      ..writeByte(1)
      ..write(obj.yearOfExperiance)
      ..writeByte(2)
      ..write(obj.userLanguages)
      ..writeByte(3)
      ..write(obj.mobileNumber)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.supportingTiming)
      ..writeByte(6)
      ..write(obj.positionfor)
      ..writeByte(7)
      ..write(obj.basePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralSettingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
