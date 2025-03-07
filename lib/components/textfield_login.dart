// custom_text_form_field.dart
import 'package:cyfeer_apartment_handover/util/constants.dart';
import 'package:flutter/material.dart';

class TextFieldLogin extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final TextStyle? textStyle;
  const TextFieldLogin({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        cursorColor: kPrimaryColor,
        style: textStyle ??
            const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: prefixIcon,
                )
              : null,
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
      ),
    );
  }
}
