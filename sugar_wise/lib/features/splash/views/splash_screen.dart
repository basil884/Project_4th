import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    // تشغيل العداد بمجرد بناء الشاشة
    _viewModel.startSplashTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية بيضاء سادة كما في الصورة
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(), // يدفع اللوجو إلى المنتصف
            // 1. اللوجو (صورة التطبيق)
            Image.asset(
              'assets/images/logo/logo.png', // ✅ تأكد من صحة مسار صورتك
              width: 350,
              height: 350,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                size: 100,
                color: Colors.grey,
              ),
            ),

            const Spacer(), // يدفع الأنيميشن إلى الأسفل
            // 2. الأنيميشن (الثلاث نقاط الملونة)
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: SpinKitThreeBounce(
                size: 25.0, // حجم النقاط
                itemBuilder: (BuildContext context, int index) {
                  // تلوين النقاط لتطابق صورتك تماماً (أخضر، أزرق فاتح، أزرق غامق)
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

  // دالة مساعدة لاختيار لون كل نقطة بناءً على ترتيبها
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
  // دالة تبدأ بمجرد فتح الشاشة
  void startSplashTimer(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // التحقق من أن الشاشة ما زالت مفتوحة قبل الانتقال
      if (!context.mounted) return;

      // الانتقال للشاشة التالية وإغلاق شاشة البداية تماماً (حتى لا يعود لها المستخدم بزر الرجوع)
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
    });
  }
}
