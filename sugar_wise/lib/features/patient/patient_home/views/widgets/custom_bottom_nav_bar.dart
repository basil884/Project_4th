// import 'package:flutter/material.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   const CustomBottomNavBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // 1. نقوم بحساب isDark هنا لأن الـ context متوفر في دالة build
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: isDark ? Colors.transparent : Colors.black12,
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           // 2. نقوم بتمرير المتغير isDark كهدية للدالة لكي تستخدمه
//           _buildNavItem(Icons.home, 0, isDark),
//           _buildNavItem(Icons.calendar_month_outlined, 1, isDark),
//           _buildNavItem(Icons.chat_bubble_outline, 2, isDark),
//           _buildNavItem(Icons.settings_outlined, 3, isDark),
//           _buildNavItem(Icons.notifications_outlined, 4, isDark),
//         ],
//       ),
//     );
//   }

//   // 3. قمنا بتحديث الدالة لتستقبل isDark
//   Widget _buildNavItem(IconData icon, int index, bool isDark) {
//     return GestureDetector(
//       onTap: () => onItemTapped(index),
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         child: Icon(
//           icon,
//           size: 30,
//           color: selectedIndex == index
//               ? Color(0xFF10B981)
//               : (isDark ? Colors.grey[500] : Colors.grey),
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.home_filled, 0),
          _buildNavItem(Icons.calendar_month_outlined, 1),
          _buildNavItem(Icons.chat_bubble_outline, 2),
          _buildNavItem(Icons.person_outline, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: isSelected
            ? const Color(0xFF257BF4)
            : Colors.transparent,
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFffffff) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}
