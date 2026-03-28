import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/insulin_calculator_patient/view_model_insulin/view_model_insulin.dart';
import 'package:sugar_wise/features/patient/laptests/lab_tests_view_model/lab_tests_view_model.dart';
import 'package:sugar_wise/features/patient/monitoring_patient/view_model/monitoring_view_model.dart';
import 'package:sugar_wise/features/patient/notfications/notfication/view_model/notifications_view_model.dart';
import 'package:sugar_wise/features/patient/orders/orders_view_model/orders_view_model.dart';

import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';
import 'package:sugar_wise/features/patient/seetings/settings_view_model.dart';
import 'package:sugar_wise/features/splash/views/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => InsulinViewModel()),
        ChangeNotifierProvider(create: (_) => MonitoringViewModel()),
        ChangeNotifierProvider(create: (_) => LabTestsViewModel()),
        ChangeNotifierProvider(create: (_) => OrdersViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sugar Wise',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
