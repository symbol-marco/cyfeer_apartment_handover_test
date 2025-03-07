import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';
import 'package:cyfeer_apartment_handover/util/enum/room_type.dart';

class ChecklistApartmentState {
  final HandoverSchedule handoverSchedule;

  ChecklistApartmentState({required this.handoverSchedule});
  HandoverChecklist get checklist => handoverSchedule.checklist;

  ChecklistApartmentState copyWith({
    HandoverChecklist? checklist,
  }) {
    return ChecklistApartmentState(
      handoverSchedule: handoverSchedule.copyWith(
        checklist: checklist ?? this.checklist,
        apartmentCode: checklist?.apartmentCode ?? this.checklist.apartmentCode,
        date: handoverSchedule.date,
        status: handoverSchedule.status,
        assignedTo: handoverSchedule.assignedTo,
        scheduleId: handoverSchedule.scheduleId,
        id: handoverSchedule.id,
      ),
    );
  }

  ChecklistApartmentState newStateChecklist(
      CheckerItem checkerItem, RoomType roomType) {
    final items = checklist.getItemsByRoomType(roomType);
    final updatedItems = items.map((item) {
      if (item.id == checkerItem.id) {
        return checkerItem;
      }
      return item;
    }).toList();

    final updatedChecklist = HandoverChecklist(
      completionStatus: checklist.completionStatus,
      isCompleted: checklist.isCompleted,
      kitchenItems:
          roomType == RoomType.kitchen ? updatedItems : checklist.kitchenItems,
      bedroomItems:
          roomType == RoomType.bedroom ? updatedItems : checklist.bedroomItems,
      livingRoomItems: roomType == RoomType.livingRoom
          ? updatedItems
          : checklist.livingRoomItems,
      balconyItems:
          roomType == RoomType.balcony ? updatedItems : checklist.balconyItems,
      apartmentCode: checklist.apartmentCode,
      handoverDate: checklist.handoverDate,
    );

    return copyWith(checklist: updatedChecklist);
  }

  int getVerifiedCountByRoomType(RoomType roomType) {
    final items = checklist.getItemsByRoomType(roomType);
    return items.where((item) => item.isVerified).length;
  }
}
