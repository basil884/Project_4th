import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String avatarPath;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                backgroundImage: AssetImage(avatarPath),
                onBackgroundImageError:
                    (_, _) {}, // منع الكراش لو الصورة غير موجودة
                child: avatarPath.isEmpty ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 10),
              Text(
                userName,
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
              'assets/images/logo/logo.png',
              height: 70,
              errorBuilder: (c, e, s) => const Text("Sugar Wise"),
            ),
          ],
        ),
      ],
    );
  }
}
