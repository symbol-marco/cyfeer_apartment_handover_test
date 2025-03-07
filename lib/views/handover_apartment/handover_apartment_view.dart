import 'package:cyfeer_apartment_handover/view_models/handover_schedule_viewmodel.dart';
import 'package:cyfeer_apartment_handover/components/handover_schedule_block.dart';
import 'package:cyfeer_apartment_handover/components/handover_sliver_app_bar.dart';
import 'package:cyfeer_apartment_handover/components/table_calender_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../components/handover_apartment_search.dart';

class HandoverApartmentView extends ConsumerStatefulWidget {
  const HandoverApartmentView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HandoverApartmentViewState();
}

class _HandoverApartmentViewState extends ConsumerState<HandoverApartmentView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(handoverScheduleViewmodelProvider);
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: SafeArea(
          maintainBottomViewPadding: true,
          bottom: false,
          child: ColoredBox(
            color: Colors.white,
            child: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: [
                HandoverSliverAppBar(),
                SliverToBoxAdapter(
                  child: HandoverApartmentSearch(),
                ),
                SliverPersistentHeader(
                  floating: true,
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                      maxHeight: 150,
                      minHeight: 145,
                      child: TableCalenderView(
                        onDateChanged: (value) => ref
                            .read(handoverScheduleViewmodelProvider.notifier)
                            .loadHandoverSchedules(value),
                      )),
                ),
                if (state.handoverSchedules.isEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Gap(100),
                        SvgPicture.asset('assets/icons/finish_part.svg'),
                        const Text(
                          'Không có lịch bàn giao nào',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ...state.handoverSchedules.map((schedules) {
                  final index = state.handoverSchedules.indexOf(schedules);
                  return HandoverScheduleBlock(
                      key: ValueKey(schedules),
                      title: 'Lịch bàn giao #${index + 1}',
                      schedules: schedules);
                }),
              ],
            ),
          ),
        ));
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
