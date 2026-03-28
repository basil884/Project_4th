import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/appearance_theme/apperance_bottom.dart';
import 'package:sugar_wise/features/patient/appearance_theme/apperance_drop.dart';

class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Interface Theme",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            "Select how you want the dashboard to look.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),
          const ThemeDropdown(),
          const SizedBox(height: 25),
          const Align(alignment: Alignment.centerRight, child: SaveButton()),
        ],
      ),
    );
  }
}
