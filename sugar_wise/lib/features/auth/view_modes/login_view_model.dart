import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners(); // لتحديث الواجهة عند الضغط على العين
  }

  // دالة تسجيل الدخول (سيتم برمجتها لاحقاً مع الـ API)
  void login(BuildContext context) {
    // Navigate to Home
  }
}
