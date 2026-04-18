// import 'package:flutter/material.dart';
// import 'package:sugar_wise/features/patient/booking_patient/booking_patient.dart';
// import 'package:sugar_wise/features/patient/notfications_patient/notfication/view/notifications_view.dart';
// import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/views/patient_chats_view.dart';
// import 'package:sugar_wise/features/patient/patient_home/views/patient_dashboard_view.dart';
// import 'package:sugar_wise/features/patient/patient_home/views/widgets/custom_bottom_nav_bar.dart';
// import 'package:sugar_wise/features/patient/seetings/setting_screen.dart';

// class PatientMain extends StatefulWidget {
//   const PatientMain({super.key});

//   @override
//   State<PatientMain> createState() => _PatientMainState();
// }

// class _PatientMainState extends State<PatientMain> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const PatientHomeView(),
//     const BookingScreen(),
//     const PatientChatsView(),
//     const SettingsScreenPatient(),
//     const NotificationsView(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(index: _selectedIndex, children: _pages),
//       bottomNavigationBar: CustomBottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/booking_patient/booking_patient.dart';
import 'package:sugar_wise/features/patient/chat_patient/patient_chats_to_doctor/views/patient_chats_view.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/custom_sidebar.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/profile_view.dart';
import '../view_models/dashboard_view_model.dart';
import 'patient_dashboard_view.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class PatientMainLayout extends StatefulWidget {
  const PatientMainLayout({super.key});

  @override
  State<PatientMainLayout> createState() => _PatientMainLayoutState();
}

class _PatientMainLayoutState extends State<PatientMainLayout> {
  int _currentIndex = 0;

  // قائمة الشاشات (الآن لدينا الرئيسية فقط، يمكنك إضافة الباقي لاحقاً)
  final List<Widget> _pages = [
    const PatientDashboardView(),
    const BookingScreen(),
    const PatientChatsView(),
    const ProfileView(),
    // const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Scaffold(
        backgroundColor: const Color(
          0xFFF5F7FA,
        ), // لون الخلفية الرمادي الفاتح جداً
        drawer: CustomSidebar(),
        body: SafeArea(
          child: Stack(
            children: [
              // 1. المحتوى الرئيسي
              _pages[_currentIndex],

              // 2. الـ Bottom Navigation Bar العائم
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
