import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  // دالة لاختيار العنصر مع إضافة تأثير النقر (Delay) ثم الانتقال
  void selectItem(int index, VoidCallback onNavigate) {
    _selectedIndex = index;
    notifyListeners();

    // تأخير بسيط لإظهار اللون الأزرق للمستخدم قبل الانتقال
    Future.delayed(const Duration(milliseconds: 150), () {
      onNavigate(); // تنفيذ الانتقال للشاشة المطلوبة

      // إعادة تعيين الاختيار حتى لا يظل أزرقاً عند العودة للشاشة
      _selectedIndex = -1;
      notifyListeners();
    });
  }

  void logout(BuildContext context) {
    // ضع هنا منطق تسجيل الخروج (مثل مسح التوكين من SharedPreferences)
    // print("User Logged Out!");
    Navigator.pop(context);
  }
}
