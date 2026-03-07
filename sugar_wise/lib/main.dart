import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'features/splash/views/splash_screen.dart'; // تأكد من مسار شاشة البداية

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // بما أنك تستخدم AdaptiveTheme، يجب أن يكون MaterialApp بداخله
    return AdaptiveTheme(
      light: ThemeData.light(), // إعدادات الثيم الفاتح الخاصة بك
      dark: ThemeData.dark(), // إعدادات الثيم الداكن الخاصة بك
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,

        // ✅ الحل هنا: ضع شاشة البداية داخل الـ MaterialApp
        home: const SplashScreen(),
      ),
    );
  }
}
