import 'package:flutter/material.dart';
import 'package:sugar_wise/core/color/color.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final PatientProfileModel patient;

  const ProfileHeader({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              // استخدمنا ClipOval عشان نقص الصورة بشكل دائري
              ClipOval(
                child: Container(
                  width: 80, // العرض والارتفاع 80 عشان يعادل radius: 40 القديم
                  height: 80,
                  color: Colors.white.withValues(
                    alpha: 0.2,
                  ), // لون الخلفية البديل
                  // 1. لو المسار مش فاضي، حاول تعرض الصورة
                  child: patient.imageUrl.isNotEmpty
                      ? Image.asset(
                          patient.imageUrl,
                          fit: BoxFit.cover,
                          // 2. لو المسار موجود بس غلط أو الصورة مش موجودة، اعرض ده
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            );
                          },
                        )
                      // 3. لو المسار فاضي من الأساس، اعرض ده
                      : const Icon(Icons.person, size: 40, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // كود تغيير الصورة لاحقاً
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            patient.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            patient.role,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
