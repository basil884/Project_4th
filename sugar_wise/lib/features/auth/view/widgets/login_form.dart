import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/custom_text_field.dart';
import 'package:sugar_wise/features/auth/view_modes/login_view_model.dart';
import 'package:sugar_wise/features/patient/patient_home/views/patient_main_layout.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

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
            label: "Email Address",
            hintText: "you@example.com",
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          CustomTextField(
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
          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PatientMain()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
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
            onTap: () {
              // Navigate to Sign Up
            },
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
