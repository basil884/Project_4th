import 'package:flutter/material.dart';
import '../../models/clinic_model.dart';

class BookAppointmentSheet extends StatefulWidget {
  final ClinicModel clinic; // ✅ تستقبل العيادة التي تم الضغط عليها

  const BookAppointmentSheet({super.key, required this.clinic});

  @override
  State<BookAppointmentSheet> createState() => _BookAppointmentSheetState();
}

class _BookAppointmentSheetState extends State<BookAppointmentSheet> {
  String? selectedDay;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // تحويل نص الأيام إلى قائمة (List) لنتمكن من عرضها كأزرار
    final List<String> daysList = widget.clinic.availableDays.split(', ');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // لتأخذ مساحة المحتوى فقط
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. العنوان وزر الإغلاق
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book Appointment",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    widget.clinic.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[400]),
                onPressed: () => Navigator.pop(context), // إغلاق النافذة
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. صندوق العنوان والخرائط
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.clinic.address,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.copy,
                          size: 16,
                          color: Colors.grey,
                        ),
                        label: const Text(
                          "Copy\nAddress",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.map, size: 16),
                        label: const Text(
                          "Open in\nMaps",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2962FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // 3. اختيار اليوم
          const Text(
            "SELECT DAY",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: daysList
                .map(
                  (day) => _buildSelectionPill(
                    text: day,
                    isSelected: selectedDay == day,
                    onTap: () => setState(() => selectedDay = day),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 25),

          // 4. اختيار الوقت
          const Text(
            "SELECT TIME",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.clinic.availableTimes.map((time) {
              // مثال: جعل وقت 1:00 PM محجوزاً مسبقاً (غير متاح) لتطابق صورتك
              bool isBooked = time == "01:00 PM";
              return _buildSelectionPill(
                text: time,
                isSelected: selectedTime == time,
                isBooked: isBooked,
                onTap: isBooked
                    ? null
                    : () => setState(() => selectedTime = time),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),

          // 5. السعر وزر التأكيد
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Consultation Fee",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                widget.clinic.price,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: (selectedDay != null && selectedTime != null)
                  ? () {
                      // تنفيذ كود الدفع أو الحجز هنا
                    }
                  : null, // الزر لا يعمل إلا إذا اختار يوماً ووقتاً
              icon: const Icon(Icons.verified_user_outlined, size: 20),
              label: const Text(
                "Confirm & Pay",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2962FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(height: 10), // مسافة للأسفل
        ],
      ),
    );
  }

  // دالة مساعدة لرسم أزرار الاختيار (الأيام والأوقات)
  Widget _buildSelectionPill({
    required String text,
    required bool isSelected,
    bool isBooked = false,
    required VoidCallback? onTap,
  }) {
    Color borderColor = isSelected ? Colors.blue : Colors.grey[300]!;
    Color textColor = isSelected
        ? Colors.blue
        : (isBooked ? Colors.red[200]! : Colors.grey[600]!);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isBooked ? Colors.grey[200]! : borderColor,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            decoration: isBooked
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
