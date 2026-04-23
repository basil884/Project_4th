import 'package:flutter/material.dart';
// استدعاء ملفاتك الخاصة
import 'package:sugar_wise/features/doctor/doctor_view_patient/view/doctor_view_patient.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/view/insulin_calculator_patient.dart';
import 'package:sugar_wise/features/patient/laptests/view/lab_tests_view.dart';
import 'package:sugar_wise/features/patient/monitoring_patient/view/monitoring_view.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';

class HealthDashprod extends StatelessWidget {
  const HealthDashprod({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة تحتوي على بيانات كل كارت لتقليل التكرار في الكود
    final List<Map<String, dynamic>> dashboardItems = [
      {
        'title': 'Monitoring',
        'icon': Icons.monitor_heart_outlined,
        'color': const Color(0xFF4DB6AC), // Teal
        'page': const MonitoringView(),
      },
      {
        'title': 'Profile',
        'icon': Icons.person_outline,
        'color': const Color(0xFF4DB6AC), // Teal
        'page': const ProfileView(),
      },
      {
        'title': 'Lab Test',
        'icon': Icons.science_outlined,
        'color': const Color(0xFF7986CB), // Indigo
        'page': const LabTestsView(),
      },
      {
        'title': 'My Doctor',
        'icon': Icons.medical_services_outlined,
        'color': const Color(0xFF64B5F6), // Blue
        'page': const DoctorViewToPatient(),
      },
      {
        'title': 'Dietary',
        'icon': Icons.restaurant_menu,
        'color': const Color(0xFFFFB74D), // Orange
        'page': const InsulCalculatorPatient(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // لون خلفية مريح للعين
      appBar: AppBar(
        title: const Text(
          'Health Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: TweenAnimationBuilder(
        // أنيميشن لدخول الشاشة (Fade & Slide)
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(), // تأثير سحب مرن
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عنصرين في كل صف
              crossAxisSpacing: 20, // المسافة الأفقية
              mainAxisSpacing: 20, // المسافة العمودية
              childAspectRatio: 1.0, // جعل الكروت مربعة
            ),
            itemCount: dashboardItems.length,
            itemBuilder: (context, index) {
              return AnimatedDashboardCard(
                title: dashboardItems[index]['title'],
                icon: dashboardItems[index]['icon'],
                color: dashboardItems[index]['color'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => dashboardItems[index]['page'],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ويدجت الكارت مع تأثير الانكماش عند الضغط
// ==========================================
class AnimatedDashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AnimatedDashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimatedDashboardCard>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 100),
          lowerBound: 0.0,
          upperBound: 0.05, // نسبة الانكماش
        )..addListener(() {
          setState(() {});
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap(); // تنفيذ الانتقال بعد رفع الإصبع
  }

  void _tapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTapCancel: _tapCancel,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.color.withOpacity(0.7), widget.color],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
