import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyfeer_apartment_handover/view_models/handover_schedule_viewmodel.dart';

class HandoverApartmentSearch extends ConsumerWidget {
  const HandoverApartmentSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Tìm kiếm...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0)),
        style: TextStyle(fontSize: 16.0),
        onChanged: (value) {
          ref
              .read(handoverScheduleViewmodelProvider.notifier)
              .searchByApartmentCode(value);
        },
      ),
    );
  }
}
