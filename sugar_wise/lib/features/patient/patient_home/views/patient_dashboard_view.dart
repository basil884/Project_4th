import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/patient_home/view_models/dashboard_view_model.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/service_grid_card.dart';

class PatientHomeView extends StatelessWidget {
  const PatientHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: const _PatientDashboardContent(),
    );
  }
}

class _PatientDashboardContent extends StatelessWidget {
  const _PatientDashboardContent();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // SafeArea هنا ممتازة عشان الشاشات اللي فيها نوتش
      body: SafeArea(
        // استخدمنا Consumer هنا عشان نعمل Rebuild للجزء ده بس لما البيانات تتغير
        child: Consumer<DashboardViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. الهيدر
                  DashboardHeader(),
                  const SizedBox(height: 15),

                  // 2. الترحيب (تم فصله لتنظيف الكود)
                  _buildGreetingSection(viewModel, isDark),
                  const SizedBox(height: 30),

                  // 3. شبكة الكروت (الـ Grid)
                  GridView.builder(
                    shrinkWrap: true, // ضروري داخل الـ SingleChildScrollView
                    physics:
                        const NeverScrollableScrollPhysics(), // لمنع التمرير المزدوج
                    itemCount: viewModel.cards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // كارتين في كل صف
                          crossAxisSpacing: 15, // المسافة الأفقية بين الكروت
                          mainAxisSpacing: 15, // المسافة العمودية
                          childAspectRatio: 0.85, // للتحكم في طول وعرض الكارت
                        ),
                    itemBuilder: (context, index) {
                      return ServiceGridCard(card: viewModel.cards[index]);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // دالة منفصلة لبناء قسم الترحيب لتخفيف الـ Build Method
  Widget _buildGreetingSection(DashboardViewModel viewModel, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewModel.greeting,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          viewModel.subGreeting,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
