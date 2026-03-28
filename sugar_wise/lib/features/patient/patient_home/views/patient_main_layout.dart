import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/booking_patient/booking_patient.dart';
import 'package:sugar_wise/features/patient/notfications/notfication/view/notifications_view.dart';
import 'package:sugar_wise/features/patient/patient_chats/views/patient_chats_view.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_dashboard_view.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/custom_bottom_nav_bar.dart';
import 'package:sugar_wise/features/patient/seetings/setting_screen.dart';

class PatientMain extends StatefulWidget {
  const PatientMain({super.key});

  @override
  State<PatientMain> createState() => _PatientMainState();
}

class _PatientMainState extends State<PatientMain> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PatientHomeView(),
    const BookingScreen(),
    const PatientChatsView(),
    const SettingsScreenPatient(),
    const NotificationsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
