import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/auth/view_modes/login_view_model.dart';
import 'widgets/login_header.dart';
import 'widgets/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون الخلفية الداكن (الجزء العلوي)
      backgroundColor: const Color(0xFF37474F),
      body: SafeArea(
        bottom: false, // ليمتد اللون الأبيض لأسفل الشاشة
        child: Column(
          children: [
            const SizedBox(height: 30), // مسافة من الأعلى
            // الجزء الأبيض المنحني
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA), // لون أبيض مائل للرمادي الفاتح جداً
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: const [
                      SizedBox(height: 20),
                      LoginHeader(),
                      SizedBox(height: 40),
                      LoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
