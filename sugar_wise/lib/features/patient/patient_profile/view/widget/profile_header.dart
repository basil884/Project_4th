import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_profile/edit_profile_patient/edit_profile_patient.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

class ProfileHeader extends StatelessWidget {
  final PatientProfileModel patient;

  const ProfileHeader({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B48FF), Color(0xFFFF5E3A)], // أزرق إلى برتقالي
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // 1. صورة المريض (مع إمكانية الضغط عليها للتكبير)
          GestureDetector(
            onTap: () {
              // ✅ عند الضغط، ننتقل لشاشة عرض الصورة المرفقة بالأسفل
              if (patient.imageUrl.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        _FullScreenImageView(imageUrl: patient.imageUrl),
                  ),
                );
              }
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // ✅ استخدمنا Hero لعمل أنيميشن طيران للصورة عند فتحها
                Hero(
                  tag: 'profile_image',
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: patient.imageUrl.startsWith('assets/')
                          ? AssetImage(patient.imageUrl) as ImageProvider
                          : FileImage(File(patient.imageUrl)),
                      // الأيقونة الرمادية تظهر فقط إذا لم يكن هناك أي صورة
                      child: patient.imageUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                ),

                // علامة الصح البرتقالية
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFFE65100),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 2. اسم المريض
          Text(
            patient.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // 3. البادجات (PATIENT & ID)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "PATIENT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "ID: ${patient.patientId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. زر تعديل الملف
          ElevatedButton.icon(
            onPressed: () {
              final viewModel = Provider.of<ProfileViewModel>(
                context,
                listen: false,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(viewModel: viewModel),
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Color(0xFF6B48FF), size: 16),
            label: const Text(
              "Edit Profile",
              style: TextStyle(
                color: Color(0xFF6B48FF),
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ✅ شاشة جديدة مصغرة لعرض الصورة بالحجم الكامل
// ==========================================
class _FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء لبروز الصورة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // سهم العودة باللون الأبيض
      ),
      body: Center(
        // InteractiveViewer يسمح للمستخدم بعمل Zoom (تكبير وتصغير) بإصبعيه
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag:
                'profile_image', // نفس التاج الموجود في الصورة الدائرية لربط الأنيميشن
            child: imageUrl.startsWith('assets/')
                ? Image.asset(imageUrl, fit: BoxFit.contain)
                : Image.file(File(imageUrl), fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
