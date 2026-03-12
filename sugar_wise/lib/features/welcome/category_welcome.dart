import 'package:flutter/material.dart';
import 'package:sugar_wise/features/auth/view/login_view.dart';

class ItemWelcome extends StatelessWidget {
  const ItemWelcome({
    super.key,
    required this.urlimage,
    required this.textfirst,
    required this.description,
    required this.textbutton,
    required this.movescreen,
  });

  final String urlimage;
  final String textfirst;
  final String description;
  final String textbutton;
  final Widget movescreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Sugar Wise',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // محتوى الصفحة
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 20.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const LoginView(),
                          ),
                        );
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  // يسمح للعمود بالامتداد لملء المساحة المتبقية بعد زر Skip
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // الصورة
                        Image.asset(
                          urlimage,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.45,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person);
                          },
                        ),
                        const SizedBox(height: 30),
                        // العنوان
                        Text(
                          textfirst,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // الوصف
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF757575),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 100), // مسافة من الأسفل للزر
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // الزر السفلي (Next)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => movescreen),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF10B981), // لون أزرق
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      textbutton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
