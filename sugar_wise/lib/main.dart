import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ المكتبة السحرية
import 'package:sugar_wise/core/api/api_client.dart';
import 'package:sugar_wise/core/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:sugar_wise/features/doctor/doctor_dashboard/view/doctor_dashboard.dart';
import 'package:sugar_wise/features/patient/bluetooth_scanner/View_Models/bluetooth_scanner_view_model.dart';

// 🔥 استيرادات شاشات الدكتور الجديدة
import 'package:sugar_wise/features/doctor/profile_doctor/doctor_profile/view_model/doctor_profile_view_model.dart';
// --- استيرادات الـ ViewModels الخاصة بك ---
import 'package:sugar_wise/features/patient/insulin_calculator_patient/view_model_insulin/view_model_insulin.dart';
import 'package:sugar_wise/features/patient/laptests/lab_tests_view_model/lab_tests_view_model.dart';
import 'package:sugar_wise/features/patient/monitoring_patient/view_model/monitoring_view_model.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/view_model/notifications_view_model.dart';
import 'package:sugar_wise/features/patient/orders/orders_view_model/orders_view_model.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';
import 'package:sugar_wise/features/patient/seetings/settings_view_model.dart';

import 'package:sugar_wise/features/splash/views/splash_screen.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة مكتبة الـ API (Dio) مرة واحدة في بداية التطبيق
  ApiClient.init();
  // ✅ تهيئة مكتبة الترجمة
  await EasyLocalization.ensureInitialized();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  bool isLoggedIn = await SharedPrefsHelper.getLoginState();
  String? role = await SharedPrefsHelper.getUserRole();

  runApp(
    // ✅ تغليف التطبيق بالكامل במكتبة الترجمة
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations', // مسار ملفات الـ JSON
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) {
              var profileViewModel = ProfileViewModel();
              profileViewModel.loadProfileData();
              return profileViewModel;
            },
          ),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
          ChangeNotifierProvider(create: (_) => InsulinViewModel()),
          ChangeNotifierProvider(create: (_) => MonitoringViewModel()),
          ChangeNotifierProvider(create: (_) => LabTestsViewModel()),
          ChangeNotifierProvider(create: (_) => OrdersViewModel()),
          ChangeNotifierProvider(create: (_) => NotificationsViewModel()),
          ChangeNotifierProvider(create: (_) => BluetoothScannerViewModel()),

          // 🔥 إضافة الـ ViewModel الخاص بالطبيب ليكون متاحاً في كامل التطبيق
          ChangeNotifierProvider(create: (_) => DoctorProfileViewModel()),
        ],
        child: MyApp(
          isLoggedIn: isLoggedIn,
          role: role,
          savedThemeMode: savedThemeMode,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role;
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    this.role,
    this.savedThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        primaryColor: const Color(0xFF10B981),
        cardColor: Colors.white,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF10B981),
        cardColor: const Color(0xFF1E1E1E),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sugar Wise',
        theme: theme,
        darkTheme: darkTheme,

        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        home: _getInitialScreen(),
      ),
    );
  }

  Widget _getInitialScreen() {
    if (isLoggedIn && role != null) {
      if (role == 'patient') return const PatientMain();

      // 🔥 التعديل هنا: توجيه الدكتور للشاشة الرئيسية الأنيقة التي تحتوي على الـ Nav Bar
      if (role == 'doctor') return const DoctorDashboard();
    }
    return const SplashScreen();
  }
}
