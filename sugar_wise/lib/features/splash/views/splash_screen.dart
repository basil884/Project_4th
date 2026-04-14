import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sugar_wise/features/welcome/welcome_first_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashViewModel _viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();

    _viewModel.startSplashTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ السحر هنا: جعل لون الخلفية يتجاوب مع الثيم الفاتح والمظلم
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(),

            Image.asset(
              'assets/images/logo/logo.png',
              width: 350,
              height: 350,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported,
                size: 100,
                // ✅ لون الأيقونة الاحتياطية يتجاوب مع الثيم
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.grey,
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: SpinKitThreeBounce(
                size: 25.0,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getDotColor(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDotColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF00C853);
      case 1:
        return const Color(0xFF42A5F5);
      case 2:
        return const Color(0xFF1565C0);
      default:
        return Colors.blue;
    }
  }
}

class SplashViewModel {
  void startSplashTimer(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (!context.mounted) return;
      // الانتقال للشاشة التالية وإغلاق شاشة البداية تماماً (حتى لا يعود لها المستخدم بزر الرجوع)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeFirstScreen()),
      );
    });
  }
}
