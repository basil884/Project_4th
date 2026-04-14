import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ استدعاء البروفايدر
import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

class DashboardHeader extends StatelessWidget {
  // ✅ لم نعد بحاجة لتمرير أي متغيرات عبر الـ Constructor، سيكتشفها بنفسه!
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🔥 السحر هنا: الشاشة تستمع دائماً لأي تغيير في بيانات المريض
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final patient = profileViewModel.patientData;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // معلومات المستخدم
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileView()),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue[100],

                backgroundImage: patient.imageUrl.startsWith('assets/')
                    ? AssetImage(patient.imageUrl) as ImageProvider
                    : FileImage(File(patient.imageUrl)),
                // ✅ تقرأ الصورة الحية
                onBackgroundImageError:
                    (_, _) {}, // منع الكراش لو الصورة غير موجودة
                child: patient.imageUrl.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                (patient.name), // ✅ تقرأ الاسم الحي (سيتغير فور التعديل)
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // اللوجو وشارة النظام
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // اللوجو (استبدل المسار بصورة اللوجو الخاصة بك)
            Image.asset(
              'assets/images/logo/logoText.png',
              height: 40,
              errorBuilder: (c, e, s) => const Text("Sugar Wise"),
            ),
          ],
        ),
      ],
    );
  }
}
