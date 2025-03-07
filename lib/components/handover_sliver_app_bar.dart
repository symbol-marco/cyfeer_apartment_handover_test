import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HandoverSliverAppBar extends StatelessWidget {
  const HandoverSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
     
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () => {},
                  child: SvgPicture.asset(
                    'assets/icons/chevron_left_sharp.svg',
                    height: 24,
                    width: 24,
                  )),
              Expanded(
                child: Text('Quản lý chuyển đổi',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          Text(
            'Chung cư CYHOME - Quản lý',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[900],
      expandedHeight: 80.0,
    );
  }
}
