import 'package:cyfeer_apartment_handover/models/handover/handover_schedule_list.dart';

class HandoverScheduleState {
  final List<HandoverSchedules> handoverSchedules;

  HandoverScheduleState({
    this.handoverSchedules = const [],
  });

  HandoverScheduleState.initial() : handoverSchedules = [];

  HandoverScheduleState copyWith({
    List<HandoverSchedules>? handoverSchedules,
  }) {
    return HandoverScheduleState(
      handoverSchedules: handoverSchedules ?? this.handoverSchedules,
    );
  }
}
