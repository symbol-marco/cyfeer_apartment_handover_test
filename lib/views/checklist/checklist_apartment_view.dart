import 'package:cyfeer_apartment_handover/components/dialog_finish_view.dart';
import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';
import 'package:cyfeer_apartment_handover/util/constants.dart';
import 'package:cyfeer_apartment_handover/util/enum/room_type.dart';
import 'package:cyfeer_apartment_handover/view_models/checklist_apartment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../components/checker_item.dart';

class ChecklistApartmentView extends ConsumerStatefulWidget {
  const ChecklistApartmentView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChecklistApartmentViewState();
}

class _ChecklistApartmentViewState
    extends ConsumerState<ChecklistApartmentView> {
  @override
  Widget build(BuildContext context) {
    final checklist = ref.watch(checklistApartmentViewmodelProvider).checklist;
    final viewModel = ref.watch(checklistApartmentViewmodelProvider.notifier);

    return DefaultTabController(
      length: RoomType.values.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: false,
                backgroundColor: Color(0xff223343),
                title: Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () => viewModel.activeWarningExit(context),
                        child: SvgPicture.asset(
                          'assets/icons/chevron_left_sharp.svg',
                          height: 22,
                          width: 22,
                        )),
                    Expanded(
                      child: Text(
                          'Checklist ${ref.watch(checklistApartmentViewmodelProvider).handoverSchedule.apartmentCode}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                automaticallyImplyLeading: false,
                actions: [
                  if (viewModel.isActiveVerified())
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          DialogFinishView.showEndHandoverDialog(
                            context: context,
                            content: viewModel.messageFinishHandover(),
                            image: viewModel.imageFinishHandover(),
                            ref: ref,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Kết thúc',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                ],
                pinned: true,
                floating: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      isScrollable: true,
                      tabs: RoomType.values
                          .map((RoomType room) => Tab(text: room.displayName))
                          .toList(),
                      indicatorColor: Colors.orange,
                      labelColor: Colors.orange,
                      unselectedLabelColor: Colors.black,
                      indicatorWeight: 3.0,
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.orange,
                      ),
                      unselectedLabelStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: RoomType.values
                .map((RoomType room) => _buildChecklistPage(
                    checklist.getItemsByRoomType(room), room))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistPage(List<CheckerItem> checkers, RoomType room) {
    final verifiedCount = ref.watch(checklistApartmentViewmodelProvider
        .select((selector) => selector.getVerifiedCountByRoomType(room)));

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thông tin bàn giao',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              '$verifiedCount/${checkers.length} đã nghiệm thu',
              style: TextStyle(fontSize: 14, color: Colors.orange),
            ),
          ],
        ),
        Gap(kDefaultPadding),
        ...checkers.map((checker) => CheckerItemView(
              key: ValueKey(checker),
              item: checker,
              onChanged: (checker) => ref
                  .read(checklistApartmentViewmodelProvider.notifier)
                  .updateChecklist(checker, room),
            ))
      ],
    );
  }
}
