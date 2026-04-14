import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/features/doctor/review/review_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم الحالي
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ خلفية ديناميكية
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: null,
        title: Text(
          ('My Booking'),
          style: TextStyle(
            color: isDark
                ? Colors.white
                : const Color(0xFF2F3E2F), // ✅ لون العنوان يتغير
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCustomTabBar(isDark),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: globalDoctorsList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final doctor = globalDoctorsList[index];

                  // التعديل 1: تمرير كائن الطبيب بالكامل
                  return BookingCard(doctor: doctor, isPast: !isUpcoming);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ تمرير حالة الثيم (isDark) لتعديل ألوان التبويبات
  Widget _buildCustomTabBar(bool isDark) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]
            : const Color(0xFFE2ECE2), // ✅ خلفية التبويبات
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem(("Upcoming"), isUpcoming, isDark),
          _buildTabItem(("Past"), !isUpcoming, isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isUpcoming = title == ("Upcoming");
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                      ? Colors.grey[700]
                      : Colors.white) // ✅ لون التبويب النشط
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow:
                isActive &&
                    !isDark // ✅ إخفاء الظل في الوضع المظلم
                ? [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            (title),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? (isDark
                        ? Colors.white
                        : const Color(0xFF2F3E2F)) // ✅ لون النص النشط
                  : Colors.grey, // لون النص غير النشط
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// BookingCard المعدل لاستقبال كائن الطبيب والتجاوب مع الثيم
// ---------------------------------------------------------
class BookingCard extends StatelessWidget {
  final DoctorModle doctor;
  final bool isPast;

  const BookingCard({super.key, required this.doctor, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط ألوان الكارد
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const greenColor = Color(0xFF5B7F5B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ الكارد يقرأ لونه من الثيم
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ), // ✅ إطار متكيف
        boxShadow: [
          if (!isDark) // ✅ الظلال تظهر فقط في الوضع الفاتح
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${("Order ID")}: ${doctor.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF2F3E2F), // ✅ لون النص
                ),
              ),
              if (isPast)
                Text(
                  ("Completed"),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            ('Order Date: June 25, 2025, 10:00pm - 03:00pm'),
            style: TextStyle(
              color: isDark
                  ? Colors.grey[400]
                  : Colors.grey[500], // ✅ تباين أفضل للتاريخ
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // تفاصيل الطبيب
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  doctor.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(width: 60, height: 60, color: Colors.grey[300]),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF2F3E2F), // ✅ لون اسم الطبيب
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.rating}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white70
                              : Colors.black87, // ✅ لون التقييم
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // الأزرار
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (isPast) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WriteReviewScreen(doctor: doctor),
                        ),
                      );
                    } else {
                      // كود الإلغاء
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : const Color(0xFFEBEBEB), // ✅ لون زر الإلغاء
                    foregroundColor: isDark
                        ? Colors.white70
                        : Colors.black54, // ✅ لون نص زر الإلغاء
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(isPast ? 'Write A Review' : 'Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // يمكنك إضافة منطق زر التفاصيل هنا
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        greenColor, // ✅ احتفظنا باللون الأخضر المميز
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(isPast ? 'Book Again' : 'View Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
