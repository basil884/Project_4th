import 'package:flutter/material.dart';

class SettingModel {
  final String title;
  final String AssetImage;
  final Color iconColor;
  final VoidCallback? onTap;

  SettingModel({
    required this.title,
    required this.AssetImage,
    required this.iconColor,
    this.onTap,
  });
}