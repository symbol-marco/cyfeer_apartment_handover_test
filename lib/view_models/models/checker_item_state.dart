import 'package:cyfeer_apartment_handover/models/handover/handover_schedule.dart';

class CheckerItemState {
  CheckerItem item;

  CheckerItemState({
    required this.item,
  });

  CheckerItemState copyWith({
    String? title,
    bool? isVerified,
    String? note,
    List<String>? imageUrls,
  }) {
    return CheckerItemState(
      item: item.copyWith(
        id: item.id,
        category: title ?? item.category,
        isVerified: isVerified ?? item.isVerified,
        note: note ?? item.note,
        imageUrls: imageUrls ?? item.imageUrls,
      ),
    );
  }
}
