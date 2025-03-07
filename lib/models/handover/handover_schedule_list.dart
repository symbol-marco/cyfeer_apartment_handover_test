import 'handover_schedule.dart';

typedef HandoverSchedules = List<HandoverSchedule>;

class HandoverScheduleList {
  List<HandoverSchedules> handoverSchedules;

  HandoverScheduleList({
    required this.handoverSchedules,
  });

  factory HandoverScheduleList.from(HandoverSchedules handoverSchedules) {
    final Map<int, HandoverSchedules> groupedSchedules = {};
    for (final schedule in handoverSchedules) {
      groupedSchedules.putIfAbsent(schedule.scheduleId, () => []);
      groupedSchedules[schedule.scheduleId]!.add(schedule);
    }
    final List<HandoverSchedules> result = groupedSchedules.values.toList();
    return HandoverScheduleList(handoverSchedules: result);
  }

  @override
  String toString() {
    return 'HandoverScheduleList{handoverSchedule: $handoverSchedules}';
  }
}
