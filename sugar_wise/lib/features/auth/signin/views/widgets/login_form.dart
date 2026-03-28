import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/custom_text_field.dart';
import 'package:sugar_wise/features/auth/register/ask_registration/views/register_view.dart';
import 'package:sugar_wise/features/auth/signin/view_models/login_view_model.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_main_layout.dart';

// ✅ تم التحويل إلى StatefulWidget للتعامل مع الـ Controllers بأمان
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // 🔥 تعريف الـ Controllers لقراءة الإدخال
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // تنظيف الذاكرة عند إغلاق الشاشة
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    const Color primaryGreen = Color(0xFF10B981); // اللون الأخضر للأزرار

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05), // ظل خفيف جداً
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController, // ✅ ربط الإيميل
            label: "Email Address",
            hintText: "you@example.com",
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _passwordController, // ✅ ربط الباسوورد
            label: "Password",
            hintText: "••••••••",
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            obscureText: viewModel.obscurePassword,
            onSuffixTap: viewModel.togglePasswordVisibility,
          ),
          const SizedBox(height: 10),
          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot password?",
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 🔥 Sign In Button (التوجيه الذكي)
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null // تعطيل الزر أثناء التحميل لمنع التكرار
                  : () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text;

                      // 1. التحقق من أن الحقول غير فارغة
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please enter both email and password",
                            ),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      // 2. استدعاء العقل المدبر للتحقق من الحساب
                      final role = await viewModel.login(email, password);

                      // 3. التأكد من أن الشاشة لا تزال مفتوحة
                      if (!context.mounted) return;

                      // 4. التوجيه بناءً على نوع الحساب
                      if (role == 'patient') {
                        // 👨‍🦱 توجيه المريض لشاشته
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PatientMain(),
                          ),
                        );
                      } else if (role == 'doctor') {
                        // 👨‍⚕️ توجيه الطبيب لشاشته (مؤقتة حتى تبنيها)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Scaffold(
                              body: Center(
                                child: Text(
                                  "Doctor Dashboard\n(Coming Soon!)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        // ❌ البيانات خاطئة، نعرض الخطأ
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              viewModel.errorMessage ?? "Invalid credentials",
                            ),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: viewModel.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 25),
          // Divider (OR)
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("or", style: TextStyle(color: Colors.grey[400])),
              ),
              Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
            ],
          ),
          const SizedBox(height: 25),
          // Sign Up Link
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterView()),
            ),
            child: RichText(
              text: const TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                children: [
                  TextSpan(
                    text: "Sign up",
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
