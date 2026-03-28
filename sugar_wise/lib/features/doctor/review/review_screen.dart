import 'package:flutter/material.dart';

class WriteReviewScreen extends StatefulWidget {
  final dynamic doctor; // استقبال بيانات الطبيب

  const WriteReviewScreen({super.key, required this.doctor});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _selectedStars = 4; // القيمة الافتراضية للنجوم
  int _recommendation = 1; // 1 = Yes, 2 = No
  final TextEditingController _reviewController = TextEditingController();

  // الألوان
  final Color kPrimaryGreen = const Color(0xFF5F8D58);
  final Color kBackground = const Color(0xFFF9F9F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFEFEFEF),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'My Review',
          style: TextStyle(
            color: Color(0xFF2F3E2F),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. صورة الطبيب
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  widget.doctor.image,
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 140,
                    height: 140,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. السؤال واسم الطبيب
            const Text(
              "How was your experience with",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              "DR : ${widget.doctor.name}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2F3E2F),
              ),
            ),

            const SizedBox(height: 15),

            // 3. نجوم التقييم
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedStars = index + 1;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: index < _selectedStars
                        ? kPrimaryGreen
                        : Colors.grey[300],
                    size: 32,
                  ),
                );
              }),
            ),

            const SizedBox(height: 5),
            const Divider(thickness: 1, color: Colors.black12),
            const SizedBox(height: 15),

            // 4. حقل الكتابة
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Write your Review",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F3E2F),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: .05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Write your experience",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 5. التعديل هنا: استخدام RadioGroup

            // ✅ استخدام RadioGroup لإدارة الحالة
            // 5. السؤال والخيارات
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Would you recommended Dr. ${widget.doctor.name}?",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F3E2F),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ التصحيح: استخدام groupValue بدلاً من value
            RadioGroup<int>(
              groupValue: _recommendation, // هنا التغيير
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _recommendation = val;
                  });
                }
              },
              child: Row(
                children: [
                  // الخيار الأول
                  Radio<int>(
                    value: 1, // قيمة الزر فقط
                    activeColor: kPrimaryGreen,
                  ),
                  const Text("Yes"),

                  const SizedBox(width: 20),

                  // الخيار الثاني
                  Radio<int>(
                    value: 2, // قيمة الزر فقط
                    activeColor: kPrimaryGreen,
                  ),
                  const Text("NO"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 6. زر الإرسال
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Review Submitted Successfully!"),
                    ),
                  );
                },
                child: const Text(
                  "Submit Review",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
