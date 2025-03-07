// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HandoverScheduleAdapter extends TypeAdapter<HandoverSchedule> {
  @override
  final int typeId = 1;

  @override
  HandoverSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HandoverSchedule(
      scheduleId: fields[0] as int,
      id: fields[1] as int,
      apartmentCode: fields[2] as String,
      status: fields[3] as String,
      assignedTo: fields[4] as String,
      date: fields[5] as DateTime,
      checklist: fields[6] as HandoverChecklist,
    );
  }

  @override
  void write(BinaryWriter writer, HandoverSchedule obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.scheduleId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.apartmentCode)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.assignedTo)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.checklist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HandoverScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CheckerItemAdapter extends TypeAdapter<CheckerItem> {
  @override
  final int typeId = 3;

  @override
  CheckerItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckerItem(
      id: fields[0] as int,
      category: fields[1] as String,
      note: fields[2] as String,
      imageUrls: (fields[3] as List).cast<String>(),
      isVerified: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CheckerItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.imageUrls)
      ..writeByte(4)
      ..write(obj.isVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckerItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HandoverChecklistAdapter extends TypeAdapter<HandoverChecklist> {
  @override
  final int typeId = 2;

  @override
  HandoverChecklist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HandoverChecklist(
      apartmentCode: fields[0] as String,
      handoverDate: fields[1] as DateTime,
      kitchenItems: (fields[2] as List).cast<CheckerItem>(),
      bedroomItems: (fields[3] as List).cast<CheckerItem>(),
      livingRoomItems: (fields[4] as List).cast<CheckerItem>(),
      balconyItems: (fields[5] as List).cast<CheckerItem>(),
      completionStatus: fields[6] as CompletionStatus,
      isCompleted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HandoverChecklist obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.apartmentCode)
      ..writeByte(1)
      ..write(obj.handoverDate)
      ..writeByte(2)
      ..write(obj.kitchenItems)
      ..writeByte(3)
      ..write(obj.bedroomItems)
      ..writeByte(4)
      ..write(obj.livingRoomItems)
      ..writeByte(5)
      ..write(obj.balconyItems)
      ..writeByte(6)
      ..write(obj.completionStatus)
      ..writeByte(7)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HandoverChecklistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompletionStatusAdapter extends TypeAdapter<CompletionStatus> {
  @override
  final int typeId = 4;

  @override
  CompletionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CompletionStatus.completed;
      case 1:
        return CompletionStatus.notCompleted;
      case 2:
        return CompletionStatus.unaccomplished;
      default:
        return CompletionStatus.completed;
    }
  }

  @override
  void write(BinaryWriter writer, CompletionStatus obj) {
    switch (obj) {
      case CompletionStatus.completed:
        writer.writeByte(0);
        break;
      case CompletionStatus.notCompleted:
        writer.writeByte(1);
        break;
      case CompletionStatus.unaccomplished:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
