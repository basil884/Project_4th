import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/doctor_dashboard.dart';
import 'package:sugar_wise/features/doctor/notfications_doctor/view/view.dart';
// import '../../all_patient_to_doctor/view/my_patients_view.dart';
// import '../../notfications_doctor/view/view.dart';
// import '../../profile_doctor/doctor_profile/view/doctor_profile_view.dart';

// ملفات وهمية للشاشات التي لم تصمم بعد لتجربة الـ Nav
class DoctorScheduleView extends StatelessWidget {
  const DoctorScheduleView({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Schedule Screen")));
}

class DoctorChatView extends StatelessWidget {
  const DoctorChatView({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Chat Screen")));
}

class DoctorSettingsView extends StatelessWidget {
  const DoctorSettingsView({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Settings Screen")));
}

class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // قائمة الشاشات التي سيتم التنقل بينها عبر الـ Bottom Nav
  final List<Widget> _screens = [
    // 🔥 الشاشة الرئيسية الجديدة التي سنصممها في الخطوة الثالثة
    const DoctorHomeContent(),
    const DoctorScheduleView(), // وهمية للتجربة
    const DoctorChatView(), // وهمية للتجربة
    const DoctorSettingsView(), // وهمية للتجربة
    const NotificationsView(),
  ];

  List<Widget> get screens => _screens;

  // دالة تغيير الشاشة عند النقر على أيقونة في الناف
  void changeTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners(); // تحديث الواجهة
    }
  }
}
