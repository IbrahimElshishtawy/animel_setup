import 'package:flutter/material.dart';

class AccountHeaderIcon extends StatelessWidget {
  const AccountHeaderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 44,
        backgroundColor: const Color(0xFFF6ECF3),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3, color: const Color(0xFF4B1A45)),
          ),
          child: const Icon(
            Icons.person_outline,
            size: 40,
            color: Color(0xFF4B1A45),
          ),
        ),
      ),
    );
  }
}
