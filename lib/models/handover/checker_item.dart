part of 'handover_schedule.dart';

@HiveType(typeId: 3)
class CheckerItem {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String category;

  @HiveField(2)
  final String note;

  @HiveField(3)
  final List<String> imageUrls;

  @HiveField(4)
  final bool isVerified;

  CheckerItem({
    required this.id,
    required this.category,
    required this.note,
    required this.imageUrls,
    this.isVerified = false,
  });

  CheckerItem copyWith({
    int? id,
    String? category,
    String? note,
    List<String>? imageUrls,
    bool? isVerified,
  }) {
    return CheckerItem(
      id: id ?? this.id,
      category: category ?? this.category,
      note: note ?? this.note,
      imageUrls: imageUrls ?? this.imageUrls,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  factory CheckerItem.fromJson(Map<String, dynamic> json) {
    return CheckerItem(
      id: json['id'],
      category: json['category'],
      note: json['note'],
      imageUrls:
          json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : [],
      isVerified: json['isVerified'] ?? false,
    );
  }
  @override
  String toString() {
    return 'CheckerItem{category: $category, note: $note, imageUrls: $imageUrls, isVerified: $isVerified}';
  }
}
