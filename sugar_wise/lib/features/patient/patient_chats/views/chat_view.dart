import 'package:flutter/material.dart';
import '../models/chat_thread_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/views/doctor_details_view.dart';

// ✅ 2. موديل صغير خاص بالرسائل داخل هذه الشاشة
class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

// ✅ 3. تحويل الشاشة إلى StatefulWidget لتتفاعل مع كتابة الرسائل
class ChatView extends StatefulWidget {
  final ChatThreadModel chat;

  const ChatView({super.key, required this.chat});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    // تجهيز رسائل البداية
    messages = [
      ChatMessage(
        text: "Hello! How can I help you today?",
        isMe: false,
        time: "10:00 AM",
      ),
      ChatMessage(text: widget.chat.lastMessage, isMe: true, time: "10:05 AM"),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ 4. دالة إرسال الرسالة
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final timeString = TimeOfDay.now().format(context);

    setState(() {
      messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          isMe: true,
          time: timeString,
        ),
      );
    });

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F7F5),

      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: isDark ? Colors.white : Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        // ✅ 5. تغليف منطقة العنوان بـ GestureDetector للانتقال لصفحة الدكتور الحقيقية
        title: GestureDetector(
          onTap: () {
            // ✅ تم مسح الكود الوهمي، والآن نستخدم البيانات الحقيقية المحفوظة في المحادثة
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DoctorDetailsView(doctor: widget.chat.realDoctorDetails),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(widget.chat.doctorImage),
                backgroundColor: Colors.grey[200],
                onBackgroundImageError: (_, _) {},
                child: widget.chat.doctorImage.isEmpty
                    ? const Icon(Icons.person, size: 20)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.doctorName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Text(
                      "Online",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            color: const Color(0xFF1976D2),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            color: const Color(0xFF1976D2),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(msg: msg, isDark: isDark);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        // ✅ إصلاح زر الكيبورد: يجب أن نمرر دالة عادية، وليس استدعاء الدالة نفسها
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1976D2),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: _sendMessage,
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

  Widget _buildMessageBubble({required ChatMessage msg, required bool isDark}) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe
              ? const Color(0xFF1976D2)
              : (isDark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(msg.isMe ? 15 : 0),
            bottomRight: Radius.circular(msg.isMe ? 0 : 15),
          ),
          boxShadow: [
            if (!msg.isMe && !isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: msg.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isMe
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              msg.time,
              style: TextStyle(
                fontSize: 10,
                color: msg.isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
