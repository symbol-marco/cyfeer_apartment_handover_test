import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HandoverScheduleTile extends StatelessWidget {
  final String code;
  final String date;
  final String person;

  const HandoverScheduleTile({
    super.key,
    required this.code,
    required this.date,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.0),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Căn hộ:  $code',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            Gap(20),
            Row(
              spacing: 20,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trạng thái:'),
                    Text('Người thực hiện:'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date),
                    Text(person),
                  ],
                ),
              ],
            )
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Color(0xff3E4c59)),
      ),
    );
  }
}
