import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';
import 'package:cyfeer_apartment_handover/util/router.dart';
import 'package:cyfeer_apartment_handover/views/checklist/checklist_apartment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'handover_schedule_header.dart';
import 'handover_schedule_tile.dart';

final currentHandoverScheduleProvider =
    StateProvider<HandoverSchedule?>((ref) => null);

class HandoverScheduleBlock extends ConsumerWidget {
  final String title;
  final List<HandoverSchedule> schedules;
  const HandoverScheduleBlock(
      {super.key, required this.title, required this.schedules});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverStickyHeader(
      header: DeliveryScheduleHeader(title: title),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => GestureDetector(
            onTap: () {
              ref.read(currentHandoverScheduleProvider.notifier).state =
                  schedules[index];
              AppRouter.pushPage(context, ChecklistApartmentView());
            },
            child: HandoverScheduleTile(
              code: schedules[index].apartmentCode,
              date: schedules[index].status,
              person: schedules[index].assignedTo,
            ),
          ),
          childCount: schedules.length,
        ),
      ),
    );
  }
}
