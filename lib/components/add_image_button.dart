import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xff457DDE)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt,
              color: Color(0xff457DDE),
              size: 20.0,
            ),
            Text(
              'Thêm hình',
              style: TextStyle(
                  color: Color(0xff457DDE),
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
