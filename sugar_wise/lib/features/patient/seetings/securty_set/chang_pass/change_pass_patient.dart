import 'package:flutter/material.dart';

class ChangPassPatient extends StatefulWidget {
  const ChangPassPatient({super.key});

  @override
  State<ChangPassPatient> createState() => _ChangPassPatientState();
}

class _ChangPassPatientState extends State<ChangPassPatient> {
  // مفتاح الفورم للتحكم في الـ Validation
  final _formKey = GlobalKey<FormState>();

  // أدوات التحكم في النصوص
  final TextEditingController _oldPassCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();

  // متغيرات للتحكم في إظهار وإخفاء كلمات المرور
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  // دالة تحديث كلمة المرور
  void _updatePassword() {
    // التحقق من أن كل الشروط (Validations) صحيحة
    if (_formKey.currentState!.validate()) {
      // إغلاق الكيبورد
      FocusScope.of(context).unfocus();

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully! ✅"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // العودة للشاشة السابقة بعد ثانية
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey, // ربط الفورم بالمفتاح
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your new password must be different from your \npreviously used passwords",
                        style: TextStyle(color: Colors.grey, height: 1.5),
                      ),
                      const SizedBox(height: 32),

                      // 1. حقل كلمة المرور القديمة
                      _buildPasswordField(
                        label: "Enter old password",
                        controller: _oldPassCtrl,
                        obscureText: _obscureOld,
                        onToggleVisibility: () =>
                            setState(() => _obscureOld = !_obscureOld),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your old password";
                          }
                          return null;
                        },
                      ),

                      // 2. حقل كلمة المرور الجديدة
                      _buildPasswordField(
                        label: "Enter new password",
                        controller: _newPassCtrl,
                        obscureText: _obscureNew,
                        onToggleVisibility: () =>
                            setState(() => _obscureNew = !_obscureNew),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a new password";
                          } else if (value.length < 8) {
                            return "Password must be at least 8 characters long";
                          } else if (value == _oldPassCtrl.text) {
                            return "New password must be different from the old one"; // شرط الاختلاف
                          }
                          return null;
                        },
                      ),

                      // 3. حقل تأكيد كلمة المرور الجديدة
                      _buildPasswordField(
                        label: "Confirm new password",
                        controller: _confirmPassCtrl,
                        obscureText: _obscureConfirm,
                        onToggleVisibility: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your new password";
                          } else if (value != _newPassCtrl.text) {
                            return "Passwords do not match"; // شرط التطابق
                          }
                          return null;
                        },
                      ),

                      const Spacer(), // لدفع الزر إلى الأسفل
                      // 4. زر الحفظ
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2f66d0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _updatePassword, // تفعيل دالة الفحص
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Update Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // أداة مساعدة لبناء حقول كلمة المرور بشكل نظيف وعدم تكرار الكود
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator, // دالة التحقق من الشروط
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: onToggleVisibility, // تغيير حالة الإظهار والإخفاء
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xff2f66d0), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }
}
