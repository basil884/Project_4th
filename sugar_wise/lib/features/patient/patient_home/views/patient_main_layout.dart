import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_dashboard_view.dart';
import 'package:sugar_wise/features/patient/patient_home/views/widgets/custom_bottom_nav_bar.dart';

class PatientMain extends StatefulWidget {
  const PatientMain({super.key});

  @override
  State<PatientMain> createState() => _PatientMainState();
}

class _PatientMainState extends State<PatientMain> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PatientHomeView(),

    const Scaffold(
      body: Center(child: Text('الحجوزات', style: TextStyle(fontSize: 24))),
    ),
    const Scaffold(
      body: Center(child: Text('شات', style: TextStyle(fontSize: 24))),
    ),
    const Scaffold(
      body: Center(child: Text('الادادات', style: TextStyle(fontSize: 24))),
    ),
    const Scaffold(
      body: Center(child: Text('الاشعارات', style: TextStyle(fontSize: 24))),
    ),
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
