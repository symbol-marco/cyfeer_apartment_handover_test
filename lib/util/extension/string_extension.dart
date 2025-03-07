extension AuthenValidation on String {
  bool isValidVietnamPhoneNumber() {
    final RegExp phoneRegExp = RegExp(
      r'^(0[35789][0-9]{8}|(\+84)[35789][0-9]{8})$',
    );
    return phoneRegExp.hasMatch(this);
  }

  bool isValidPassword() {
    return length >= 6;
  }
}
