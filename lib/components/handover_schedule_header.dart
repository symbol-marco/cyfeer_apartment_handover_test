import 'package:cyfeer_apartment_handover/util/constants.dart';
import 'package:flutter/material.dart';

class DeliveryScheduleHeader extends StatelessWidget {
  const DeliveryScheduleHeader({
    super.key,
    this.index,
    this.title,
    this.color = kPrimaryHeaderColor,
  });

  final String? title;
  final int? index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      color: Color.fromARGB(255, 217, 229, 255),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        title ?? 'DeliveryScheduleHeader #$index',
        style: const TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
