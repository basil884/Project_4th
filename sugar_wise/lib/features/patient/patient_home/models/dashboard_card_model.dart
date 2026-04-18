import 'package:flutter/material.dart';

// class DashboardCardModel {
//   final String title;
//   final String description;
//   final IconData smallIcon;
//   final IconData largeIcon;
//   final Color themeColor;
//   final Widget movescreen;

//   DashboardCardModel({
//     required this.title,
//     required this.description,
//     required this.smallIcon,
//     required this.largeIcon,
//     required this.themeColor,
//     required this.movescreen,
//   });
// }

class SpecialtyModel {
  final String name;
  final String iconPath; // يمكن استبدالها بـ IconData إذا لم تستخدم صور SVG

  SpecialtyModel({required this.name, required this.iconPath});
}

class TopDoctorModel {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;
  final bool isAvailable;

  TopDoctorModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.isAvailable,
  });
}
