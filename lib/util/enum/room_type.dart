enum RoomType { kitchen, bedroom, livingRoom, balcony }

extension RoomTypeExtension on RoomType {
  String get displayName {
    switch (this) {
      case RoomType.kitchen:
        return 'Phòng bếp';
      case RoomType.bedroom:
        return 'Phòng ngủ';
      case RoomType.livingRoom:
        return 'Phòng khách';
      case RoomType.balcony:
        return 'Ban công';
    }
  }

  String get jsonKey {
    switch (this) {
      case RoomType.kitchen:
        return 'kitchenItems';
      case RoomType.bedroom:
        return 'bedroomItems';
      case RoomType.livingRoom:
        return 'livingRoomItems';
      case RoomType.balcony:
        return 'balconyItems';
    }
  }
}
