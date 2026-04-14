import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view/doctor_view.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/view/insulin_calculator_patient.dart';
import 'package:sugar_wise/features/patient/laptests/view/lab_tests_view.dart';
import 'package:sugar_wise/features/patient/monitoring_patient/view/monitoring_view.dart';
import 'package:sugar_wise/features/patient/orders/view/orders_view.dart';
import 'package:sugar_wise/features/patient/patient_home/models/dashboard_card_model.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

class DashboardViewModel extends ChangeNotifier {
  // ✅ بيانات المستخدم (الآن ستعمل بدون خطأ لأن imageUrl أصبح موجوداً)
  final String userName = ProfileViewModel().patientData.name;
  final String userAvatar = ProfileViewModel().patientData.imageUrl;

  String get greeting => "Hello, ${userName.split(' ')[0]}";
  final String subGreeting = "Your daily health and diabetes care plan.";

  // بيانات الكروت
  final List<DashboardCardModel> cards = [
    DashboardCardModel(
      movescreen: const DoctorView(),
      title: "My Doctors",
      description: "Consult with your healthcare providers and specialists.",
      smallIcon: Icons.medical_services_outlined,
      largeIcon: Icons.monitor_heart_outlined,
      themeColor: const Color(0xFF66BB6A), // أخضر
    ),
    DashboardCardModel(
      movescreen: const MonitoringView(),
      title: "Monitoring",
      description: "Track glucose levels and insulin doses in real-time.",
      smallIcon: Icons.monitor_heart_outlined,
      largeIcon: Icons.show_chart,
      themeColor: const Color(0xFF42A5F5), // أزرق
    ),
    DashboardCardModel(
      movescreen: LabTestsView(),
      title: "Lab Tests",
      description: "View your recent laboratory results and medical reports.",
      smallIcon: Icons.receipt_long_outlined,
      largeIcon: Icons.description_outlined,
      themeColor: const Color(0xFFAB47BC), // بنفسجي
    ),
    DashboardCardModel(
      movescreen: InsulCalculatorPatient(),
      title: ("Insulin Calculator"),
      description: "Manage meal plans and calculate insulin units for food.",
      smallIcon: Icons.restaurant_outlined,
      largeIcon: Icons.flatware_outlined,
      themeColor: const Color(0xFFFFA726), // برتقالي
    ),
    DashboardCardModel(
      movescreen: OrdersView(),
      title: "Orders",
      description: "Check the status of your medical supplies orders.",
      smallIcon: Icons.shop,
      largeIcon: Icons.shopify,
      themeColor: const Color(0xFFE00A37), // برتقالي
    ),
    DashboardCardModel(
      movescreen: OrdersView(),
      title: "shop",
      description: "Check the status of your medical supplies orders.",
      smallIcon: Icons.shop,
      largeIcon: Icons.shopify,
      themeColor: const Color(0xFFE00A37), // برتقالي
    ),
  ];
}
