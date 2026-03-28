import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/features/doctor/review/review_screen.dart';
// تأكد من استيراد المودل هنا لتعريف النوع Doctor

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'My Booking',
          style: TextStyle(
            color: Color(0xFF2F3E2F),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCustomTabBar(),
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

  Widget _buildCustomTabBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2ECE2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem("Upcoming", isUpcoming),
          _buildTabItem("Past", !isUpcoming),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isUpcoming = title == "Upcoming";
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
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
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFF2F3E2F) : Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// BookingCard المعدل لاستقبال كائن الطبيب
// ---------------------------------------------------------
class BookingCard extends StatelessWidget {
  final DoctorModle doctor; // التعديل 2: استقبال كائن الطبيب
  final bool isPast;

  const BookingCard({
    super.key,
    required this.doctor, // أصبحنا نطلب الطبيب كاملاً
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF5B7F5B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFDFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(
              alpha: 0.1,
            ), // استخدمت withOpacity للتوافق العام
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
                // استخدام id من الطبيب (أو قيمة افتراضية إذا كان null)
                'Order ID: ${doctor.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF2F3E2F),
                ),
              ),
              if (isPast)
                const Text(
                  "Completed",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            'Order Date: June 25, 2025, 10:00pm - 03:00pm',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 16),

          // تفاصيل الطبيب
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  doctor.image, // استخدام البيانات من الكائن
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
                    doctor.name, // استخدام الاسم من الكائن
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF2F3E2F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.rating}', // استخدام التقييم من الكائن
                        style: const TextStyle(fontWeight: FontWeight.w500),
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
                      // التعديل 3: الانتقال وتمرير الكائن بشكل صحيح
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
                    backgroundColor: const Color(0xFFEBEBEB),
                    foregroundColor: Colors.black54,
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
                    backgroundColor: greenColor,
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
