import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/doctor_card.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';

class DoctorView extends StatefulWidget {
  const DoctorView({super.key});

  @override
  State<DoctorView> createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  String searchQuery = '';
  String selectedSpecialty = 'All Specialties';

  // قائمة التخصصات
  final List<String> specialtiesList = [
    "All Specialties",
    "Endocrine Glands",
    "Cardiologist",
    "Heart Surgeon",
  ];

  // دالة الفلترة
  List<DoctorModle> get filteredDoctors {
    return globalDoctorsList.where((doctor) {
      bool matchesSpecialty = false;
      if (selectedSpecialty == 'All Specialties') {
        matchesSpecialty = true;
      } else {
        matchesSpecialty = doctor.specialty.toLowerCase().contains(
          selectedSpecialty.toLowerCase().trim(),
        );
      }

      //  فلترة شريط البحث
      bool matchesSearch = false;
      if (searchQuery.trim().isEmpty) {
        matchesSearch = true;
      } else {
        final query = searchQuery.toLowerCase().trim();
        matchesSearch =
            doctor.name.toLowerCase().contains(query) ||
            doctor.specialty.toLowerCase().contains(query);
      }

      return matchesSpecialty && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // نحصل على القائمة المفلترة لعرضها بدلاً من القائمة الكاملة
    final displayDoctors = filteredDoctors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find the Best Doctors',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Search for doctors, specialties...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🌟 التعديل الخامس: تفعيل أزرار التخصصات
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: specialtiesList.length,
                itemBuilder: (context, index) {
                  final category = specialtiesList[index];
                  return _buildCategoryChip(
                    title: category,
                    isActive: selectedSpecialty == category,
                    onTap: () {
                      // عند الضغط على التخصص، يتم تحديث المتغير وإعادة رسم الشاشة
                      setState(() {
                        selectedSpecialty = category;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 🌟 التعديل السادس: عرض الأطباء بعد الفلترة
            Expanded(
              child: displayDoctors.isEmpty
                  // إذا لم نجد أطباء يطابقون البحث، نعرض رسالة للمستخدم
                  ? const Center(
                      child: Text(
                        "No doctors found.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  // إذا وجدنا أطباء، نعرضهم في القائمة
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: displayDoctors.length,
                      itemBuilder: (context, index) {
                        // نستخدم القائمة المفلترة (displayDoctors) بدلاً من القائمة الشاملة
                        return DoctorCard(doctor: displayDoctors[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // أداة مساعدة لبناء أزرار التخصصات (تم تعديلها لتصبح قابلة للضغط)
  Widget _buildCategoryChip({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade600 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade800,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
