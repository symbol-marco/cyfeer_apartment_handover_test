mixin JSONable {

  String toISODateString(DateTime? dateTime) {
    return dateTime?.toIso8601String() ?? '';
  }
}
