part of 'handover_schedule.dart';

@HiveType(typeId: 4)
enum CompletionStatus {
  @HiveField(0)
  completed,
  @HiveField(1)
  notCompleted,
  @HiveField(2)
  unaccomplished
}

@HiveType(typeId: 2)
class HandoverChecklist with JSONable {
  @HiveField(0)
  final String apartmentCode;
  @HiveField(1)
  final DateTime handoverDate;
  @HiveField(2)
  final List<CheckerItem> kitchenItems;
  @HiveField(3)
  final List<CheckerItem> bedroomItems;
  @HiveField(4)
  final List<CheckerItem> livingRoomItems;
  @HiveField(5)
  final List<CheckerItem> balconyItems;
  @HiveField(6)
  final CompletionStatus completionStatus;
  @HiveField(7)
  bool isCompleted;

  HandoverChecklist({
    required this.apartmentCode,
    required this.handoverDate,
    required this.kitchenItems,
    required this.bedroomItems,
    required this.livingRoomItems,
    required this.balconyItems,
    this.completionStatus = CompletionStatus.unaccomplished,
    this.isCompleted = false,
  });

  int get totalItemsAcceptance =>
      kitchenItems.length +
      bedroomItems.length +
      livingRoomItems.length +
      balconyItems.length;

  int get totalItemsVerified =>
      kitchenItems.where((item) => item.isVerified).length +
      bedroomItems.where((item) => item.isVerified).length +
      livingRoomItems.where((item) => item.isVerified).length +
      balconyItems.where((item) => item.isVerified).length;

  factory HandoverChecklist.fromJson(Map<String, dynamic> json) {
    return HandoverChecklist(
      apartmentCode: json['apartmentCode'],
      handoverDate: DateTime.parse(json['handoverDate']),
      kitchenItems: (json['kitchenItems'] as List)
          .map((item) => CheckerItem.fromJson(item))
          .toList(),
      bedroomItems: (json['bedroomItems'] as List)
          .map((item) => CheckerItem.fromJson(item))
          .toList(),
      livingRoomItems: (json['livingRoomItems'] as List)
          .map((item) => CheckerItem.fromJson(item))
          .toList(),
      balconyItems: (json['balconyItems'] as List)
          .map((item) => CheckerItem.fromJson(item))
          .toList(),
      completionStatus: CompletionStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['completionStatus'],
          orElse: () => CompletionStatus.unaccomplished),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
  List<CheckerItem> getItemsByRoomType(RoomType roomType) {
    switch (roomType) {
      case RoomType.kitchen:
        return kitchenItems;
      case RoomType.bedroom:
        return bedroomItems;
      case RoomType.livingRoom:
        return livingRoomItems;
      case RoomType.balcony:
        return balconyItems;
    }
  }

  @override
  String toString() {
    return 'HandoverChecklist{apartmentCode: $apartmentCode, handoverDate: $handoverDate, kitchenItems: $kitchenItems, bedroomItems: $bedroomItems, livingRoomItems: $livingRoomItems, balconyItems: $balconyItems, completionStatus: $completionStatus, isCompleted: $isCompleted}';
  }
}
