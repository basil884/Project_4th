import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/doctor/doctor_details/view_models/doctor_details_view_model.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DoctorDetailsViewModel>(context);
    final doctor = viewModel.doctor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // 1. الصورة وعلامة التوثيق
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[50],
              backgroundImage: AssetImage(doctor.imagePath),
              onBackgroundImageError: (_, _) {},
              child: doctor.imagePath.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            if (doctor.isVerified)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.verified, color: Colors.blue, size: 24),
              ),
          ],
        ),
        const SizedBox(height: 15),
        //name
        // 2. الاسم والمسمى الوظيفي والتخصص
        Text(
          'Dr . ${doctor.name}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        // التخصص والعمر في سطر واحد مفصولين بنقطة
        Text(
          "${doctor.age} Years",
          style: TextStyle(
            fontSize: 15,
            color: isDark
                ? Colors.grey[400]
                : const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 10),

        // المسمى الوظيفي
        Text(
          doctor.jobTitle.isEmpty ? 'There is no workplace' : doctor.jobTitle,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 2),

        // التخصص
        Text(
          doctor.specialty,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 5),
            Text(
              "${doctor.rating}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "(${doctor.reviewsCount} Reviews)",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 4. الأزرار (Follow & Message)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر المتابعة (يتغير لونه حسب الحالة)
            ElevatedButton(
              onPressed: viewModel.toggleFollow,
              style: ElevatedButton.styleFrom(
                backgroundColor: viewModel.isFollowing
                    ? Colors.grey[300]
                    : const Color(0xFF1976D2), // أزرق
                foregroundColor: viewModel.isFollowing
                    ? Colors.black
                    : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                viewModel.isFollowing ? "Following" : "Follow",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 15),
            // زر المراسلة
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE3F2FD), // أزرق فاتح
                foregroundColor: const Color(0xFF1976D2), // نص أزرق
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Message",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
