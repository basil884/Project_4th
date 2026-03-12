import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 15, spreadRadius: 2),
            ],
          ),
          child: Image.asset(
            'assets/images/logo/logo.png',
            height: 100,
            width: 100,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.monitor_heart, color: Colors.green, size: 50),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          "Sugar Wise",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1B2A3B),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Sign in to your account",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
