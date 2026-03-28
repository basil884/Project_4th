import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/patient_chats_view_model.dart';

class ChatSearchBar extends StatelessWidget {
  const ChatSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PatientChatsViewModel>(
      context,
      listen: false,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: viewModel
                  .searchChats, // يستدعي دالة البحث مع كل حرف يكتبه المستخدم
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          // زر البحث الدائري الداكن
          Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF3A4B3C), // لون زيتي غامق يطابق الصورة
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {}, // البحث يتم تلقائياً بـ onChanged، هذا للزينة
            ),
          ),
        ],
      ),
    );
  }
}
