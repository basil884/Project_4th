import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  // ===================================
  // 1. حالة إظهار وإخفاء الباسوورد (الحل للخطأ)
  // ===================================
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners(); // لتحديث أيقونة العين في الشاشة
  }

  // ===================================
  // 2. حالة تسجيل الدخول والتوجيه
  // ===================================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // دالة تسجيل الدخول ترجع (String) لتحديد الشاشة التالية
  // دالة تسجيل الدخول ترجع (String) لتحديد الشاشة التالية
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // محاكاة الاتصال بالسيرفر
    await Future.delayed(const Duration(milliseconds: 1500));

    _isLoading = false;

    // 🔥 السحر هنا: تنظيف الإيميل (إزالة المسافات + تحويله لحروف صغيرة)
    final cleanEmail = email.trim().toLowerCase();
    // تنظيف الباسوورد (إزالة أي مسافة قد تضاف بالخطأ)
    final cleanPassword = password.trim();

    // التحقق بعد التنظيف
    if (cleanEmail == 'patient@gmail.com' && cleanPassword == '123456') {
      notifyListeners();
      return 'patient';
    } else if (cleanEmail == 'doctor@gmail.com' && cleanPassword == '123456') {
      notifyListeners();
      return 'doctor';
    } else {
      _errorMessage = 'Invalid email or password. Please try again!';
      notifyListeners();
      return null;
    }
  }
}
