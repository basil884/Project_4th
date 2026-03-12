import 'package:flutter/material.dart';

class DashboardCardModel {
  final String title;
  final String description;
  final IconData smallIcon;
  final IconData largeIcon;
  final Color themeColor;
  final Widget movescreen;

  DashboardCardModel({
    required this.title,
    required this.description,
    required this.smallIcon,
    required this.largeIcon,
    required this.themeColor,
    required this.movescreen,
  });
}
