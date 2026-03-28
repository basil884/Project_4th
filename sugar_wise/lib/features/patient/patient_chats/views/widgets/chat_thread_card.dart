import 'package:flutter/material.dart';
import '../../models/chat_thread_model.dart';
import '../chat_view.dart'; // ✅ استدعاء شاشة الشات الجديدة

class ChatThreadCard extends StatelessWidget {
  final ChatThreadModel chat;
  const ChatThreadCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    // ✅ أضفنا GestureDetector هنا لالتقاط الضغطة
    return GestureDetector(
      onTap: () {
        // الانتقال لشاشة الشات الفعلية مع تمرير بيانات الدكتور
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatView(chat: chat)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1E9), // الأخضر الفاتح جداً
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. صورة الطبيب
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(chat.doctorImage),
              backgroundColor: Colors.white,
              onBackgroundImageError: (_, _) {},
              child: chat.doctorImage.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 15),

            // 2. اسم الطبيب وآخر رسالة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.doctorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3D30), // لون نص زيتي داكن
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chat.lastMessage,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
