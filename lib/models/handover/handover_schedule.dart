import 'package:cyfeer_apartment_handover/util/enum/room_type.dart';
import 'package:cyfeer_apartment_handover/util/jsonable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'checker_item.dart';
part 'handover_checklist.dart';
part 'handover_schedule.g.dart';

@HiveType(typeId: 1)
class HandoverSchedule with JSONable {
  @HiveField(0)
  final int scheduleId;
  @HiveField(1)
  final int id;
  @HiveField(2)
  final String apartmentCode;
  @HiveField(3)
  final String status;
  @HiveField(4)
  final String assignedTo;
  @HiveField(5)
  final DateTime date;
  @HiveField(6)
  final HandoverChecklist checklist;

  HandoverSchedule({
    required this.scheduleId,
    required this.id,
    required this.apartmentCode,
    required this.status,
    required this.assignedTo,
    required this.date,
    required this.checklist,
  });
  HandoverSchedule copyWith({
    int? scheduleId,
    int? id,
    String? apartmentCode,
    String? status,
    String? assignedTo,
    DateTime? date,
    HandoverChecklist? checklist,
  }) {
    return HandoverSchedule(
      scheduleId: scheduleId ?? this.scheduleId,
      id: id ?? this.id,
      apartmentCode: apartmentCode ?? this.apartmentCode,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      date: date ?? this.date,
      checklist: checklist ?? this.checklist,
    );
  }

  factory HandoverSchedule.fromJson(Map<String, dynamic> json) {
    return HandoverSchedule(
      scheduleId: json['scheduleId'],
      id: json['id'],
      apartmentCode: json['apartmentCode'],
      status: json['status'],
      assignedTo: json['assignedTo'],
      date: DateTime.parse(json['date']),
      checklist: HandoverChecklist.fromJson(json['checklist']),
    );
  }

  @override
  String toString() {
    return 'HandoverSchedule{id: $id, apartmentCode: $apartmentCode, status: $status, assignedTo: $assignedTo, date: $date, checklist: $checklist}';
  }
}
