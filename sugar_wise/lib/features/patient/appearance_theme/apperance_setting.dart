import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/appearance_theme/model/apperance_models.dart';

class SettingsItem extends StatelessWidget {
  final SettingModel model;

  const SettingsItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffF3F4F8), width: 1.5),
      ),
      child: InkWell(
        onTap: model.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: model.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(model.AssetImage, width: 22, height: 22),
              ),

              const SizedBox(width: 15),

              Text(
                model.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const Spacer(),

              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
