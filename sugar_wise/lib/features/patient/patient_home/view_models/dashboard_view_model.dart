import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view/doctor_view.dart';
import 'package:sugar_wise/features/patient/patient_home/models/dashboard_card_model.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

class DashboardViewModel extends ChangeNotifier {
  // بيانات المستخدم
  final String userName = ProfileViewModel().patientData.name;
  final String userAvatar = ProfileViewModel().patientData.imageUrl;
  String get greeting => "Hello, ${userName.split(' ')[0]}";
  final String subGreeting = "Your daily health and diabetes care plan.";

  // بيانات الكروت
  final List<DashboardCardModel> cards = [
    DashboardCardModel(
      // التعديل الأول: إزالة الفاصلة الزائدة أو وضع قيمة صحيحة للطبيب
      // ملاحظة: إذا كانت شاشة DoctorView تتطلب بيانات طبيب، يجب تمرير المتغير هنا.
      // لقد قمت بإزالة `doctor:` مؤقتاً ليعمل الكود بدون أخطاء.
      movescreen: const DoctorView(),
      title: "My Doctors",
      description: "Consult with your healthcare providers and specialists.",
      smallIcon: Icons.medical_services_outlined,
      largeIcon: Icons.monitor_heart_outlined,
      themeColor: const Color(0xFF66BB6A), // أخضر
    ),
    DashboardCardModel(
      // التعديل الثاني: إضافة 'movescreen' لأنه مطلوب في النموذج
      // استخدمنا 'SizedBox' كشاشة مؤقتة فارغة حتى تقوم بإنشاء الشاشة الحقيقية
      movescreen: const SizedBox(),
      title: "Monitoring",
      description: "Track glucose levels and insulin doses in real-time.",
      smallIcon: Icons.monitor_heart_outlined,
      largeIcon: Icons.show_chart,
      themeColor: const Color(0xFF42A5F5), // أزرق
    ),
    DashboardCardModel(
      // التعديل الثاني: إضافة 'movescreen'
      movescreen: const SizedBox(), // شاشة مؤقتة
      title: "Lab Tests",
      description: "View your recent laboratory results and medical reports.",
      smallIcon: Icons.receipt_long_outlined,
      largeIcon: Icons.description_outlined,
      themeColor: const Color(0xFFAB47BC), // بنفسجي
    ),
    DashboardCardModel(
      // التعديل الثاني: إضافة 'movescreen'
      movescreen: const SizedBox(), // شاشة مؤقتة
      title: "Dietary",
      description: "Manage meal plans and calculate insulin units for food.",
      smallIcon: Icons.restaurant_outlined,
      largeIcon: Icons.flatware_outlined,
      themeColor: const Color(0xFFFFA726), // برتقالي
    ),
  ];
}
