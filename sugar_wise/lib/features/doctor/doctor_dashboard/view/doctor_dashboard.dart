import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/color/color.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/ViewModel/home_view_model.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view/doctor_profile_view.dart';
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
// import '../../profile_doctor/doctor_profile/view/doctor_profile_view.dart';
// import '../../profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚀 حقن الـ ViewModel عند بداية الشاشة
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _DoctorHomeBody(),
    );
  }
}

class _DoctorHomeBody extends StatelessWidget {
  const _DoctorHomeBody();

  @override
  Widget build(BuildContext context) {
    // الاستماع لحالة الـ HomeViewModel لتغيير الشاشات
    final homeViewModel = Provider.of<HomeViewModel>(context);
    // جلب بيانات الدكتور من الـ ViewModel الآخر (الخاص بالبروفايل)
    final doctorProfileVM = Provider.of<DoctorProfileViewModel>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: homeViewModel
          .screens[homeViewModel.currentIndex], // عرض الشاشة الحالية
      // 🔥 تصميم الـ Bottom Navigation Bar مطابق تماماً للصورة
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: homeViewModel.currentIndex,
            onTap: homeViewModel.changeTab,
            type: BottomNavigationBarType.fixed, // هام لعرض أكثر من 3 عناصر
            backgroundColor: Colors.white,
            selectedItemColor:
                AppColors.primaryTeal, // لون الأيقونة النشطة (أخضر)
            unselectedItemColor: AppColors.textLight, // لون الأيقونات الرمادية
            showSelectedLabels: false, // إخفاء النصوص كما في الصورة
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_filled),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                label: "Schedule",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: "Chat",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: "Settings",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                label: "Notifications",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================================================================
// 🔥 محتوى الشاشة الرئيسية الحقيقي (Creative Design)
// ========================================================================
class DoctorHomeContent extends StatelessWidget {
  const DoctorHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorProfileVM = Provider.of<DoctorProfileViewModel>(
      context,
      listen: false,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. هيدر ترحيبي أنيق مع صورة البروفايل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back,",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      doctorProfileVM.doctorName,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  // النقر على الصورة يفتح البروفايل
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DoctorProfileView(),
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundImage: const NetworkImage(
                        "https://i.pravatar.cc/150?img=11",
                      ), // رابط وهمي
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 2. كروت إحصائيات سريعة (بدلاً من المربعات الزرقاء الصماء)
            Row(
              children: [
                _buildStatCard(
                  context,
                  Icons.people_outline,
                  "150+",
                  "My Patients",
                  const Color(0xFFE0E7FF),
                  const Color(0xFF4F46E5),
                ),
                const SizedBox(width: 15),
                _buildStatCard(
                  context,
                  Icons.calendar_today,
                  "8",
                  "Today's Appts.",
                  const Color(0xFFFFEDD5),
                  const Color(0xFFEA580C),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 3. قسم "مواعيد اليوم القادمة" (أهم شيء للطبيب)
            _buildSectionHeader("Upcoming Appointments"),
            const SizedBox(height: 15),
            _buildAppointmentCard(
              "Ahmed Mohamed",
              Icons.bolt,
              "Glucose Check",
              "10:30 AM",
            ),
            _buildAppointmentCard(
              "Sarah Wilson",
              Icons.science_outlined,
              "HbA1c Review",
              "01:00 PM",
            ),
          ],
        ),
      ),
    );
  }

  // ================= Components للمحتوى (Reusable Widgets) =================

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textMain,
      ),
    );
  }

  // كارت إحصائيات أنيق
  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color bgColor,
    Color iconColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }

  // كارت لموعد قادم (مطابق لهوية التطبيق في شاشة Patients)
  Widget _buildAppointmentCard(
    String name,
    IconData typeIcon,
    String typeText,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEFF6FF),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Icon(typeIcon, color: Colors.grey, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      typeText,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // الوقت في مربع أزرق أنيق
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              time,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
