import 'package:cyfeer_apartment_handover/components/dialog_finish_view.dart';
import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';
import 'package:cyfeer_apartment_handover/services/handover/handover_Schedule_service.dart';
import 'package:cyfeer_apartment_handover/util/enum/room_type.dart';
import 'package:cyfeer_apartment_handover/view_models/models/checklist_apartment_state.dart';
import 'package:cyfeer_apartment_handover/components/handover_schedule_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Provider that manages the checklist apartment state.
///
/// This provider creates and maintains a [ChecklistApartmentViewModel]
/// which is responsible for handling the apartment handover checklist logic.
final checklistApartmentViewmodelProvider =
    StateNotifierProvider<ChecklistApartmentViewModel, ChecklistApartmentState>(
        (ref) {
  final currentHandoverSchedule = ref.watch(currentHandoverScheduleProvider);
  return ChecklistApartmentViewModel(
      ref, ChecklistApartmentState(handoverSchedule: currentHandoverSchedule!));
});


/// View model for apartment handover checklist functionality.
///
/// Manages the state of a handover checklist and provides methods
/// to update, verify, and complete the handover process.
class ChecklistApartmentViewModel
    extends StateNotifier<ChecklistApartmentState> {
  /// Reference to the Riverpod container.
  final Ref _ref;

  /// Creates a new instance of [ChecklistApartmentViewModel].
  ///
  /// Requires a [Ref] for dependency injection and an initial [ChecklistApartmentState].
  ChecklistApartmentViewModel(this._ref, ChecklistApartmentState state)
      : super(state);

  /// Provides access to the handover schedule service.
  HandoverScheduleService get _handoverScheduleService =>
      _ref.read(handoverScheduleServiceProvider);

  /// Returns the current handover checklist.
  HandoverChecklist get checklist => state.handoverSchedule.checklist;

  /// Returns the count of verified items for a specific room type.
  ///
  /// [roomType] The type of room to count verified items for.
  /// Returns the number of verified items in the specified room.
  int getVerifiedCountByRoomType(RoomType roomType) {
    return state.getVerifiedCountByRoomType(roomType);
  }

  /// Updates the checklist with a new checker item status for a specific room.
  ///
  /// [checkerItem] The checker item to update.
  /// [roomType] The room type where the checker item is located.
  void updateChecklist(CheckerItem checkerItem, RoomType roomType) {
    state = state.newStateChecklist(checkerItem, roomType);
  }

  /// Completes the apartment handover process.
  /// Saves the updated handover schedule to the backend service.
  /// Returns a [Future] that completes when the update is finished.
  Future finishHandoverApartment() async {
    await _handoverScheduleService.updateHandover(
        state.handoverSchedule.id, state.handoverSchedule);
  }

  /// Determines if verification is allowed based on the scheduled date.
  ///
  /// This method checks whether the handover is scheduled for today,
  /// which indicates that verification actions should be enabled.
  /// Verification is only permitted on the actual day of the scheduled handover
  /// to ensure that inspections happen at the designated time.
  ///
  /// Returns:
  /// * `true` if the handover is scheduled for the current date, allowing verification actions
  /// * `false` otherwise, which means verification actions should be disabled
  bool isActiveVerified() {
    final today = DateTime.now();
    final handoverDate = state.handoverSchedule.date;
    // Compare year, month, and day without considering time
    return handoverDate.year == today.year &&
        handoverDate.month == today.month &&
        handoverDate.day == today.day;
  }

  void activeWarningExit(BuildContext context) {
    isActiveVerified()
        ? DialogFinishView.showUnsavedExitDialog(context)
        : Navigator.of(context).pop();
  }



  /// Returns the appropriate message for the handover completion dialog.
  ///
  /// The message varies depending on whether all items have been verified.
  /// Returns a [String] message for user confirmation.
  String messageFinishHandover() {
    if (checklist.totalItemsVerified == checklist.totalItemsAcceptance) {
      return 'Bạn đã nghiệm thu tất cả các hạng mục. Bạn có chắc chắn xác nhận hoàn thành bàn giao căn hộ?';
    } else {
      return 'Bạn đã nghiệm thu ${checklist.totalItemsVerified}/${checklist.totalItemsAcceptance} mục.Bạn có chắc chắn kết thúc lượt bàn giao này?';
    }
  }

  /// Returns the appropriate icon for the handover completion dialog.
  ///
  /// The icon varies depending on whether all items have been verified.
  /// Returns a [Widget] representing the completion status.
  Widget imageFinishHandover() {
    if (checklist.totalItemsVerified == checklist.totalItemsAcceptance) {
      return SvgPicture.asset(
        'assets/icons/finish_all.svg',
      );
    } else {
      return SvgPicture.asset('assets/icons/finish_part.svg');
    }
  }
}
