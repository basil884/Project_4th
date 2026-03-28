import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/patient_chats_view_model.dart';
import 'widgets/chat_search_bar.dart';
import 'widgets/chat_thread_card.dart';

// ✅ قمنا بإنشاء نسخة ثابتة (Singleton-like behavior) من الـ ViewModel هنا
// لكي لا يتم مسح البيانات عند الانتقال بين الشاشات في شريط التنقل السفلي
final patientChatsViewModel = PatientChatsViewModel();

class PatientChatsView extends StatelessWidget {
  const PatientChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ نستخدم ChangeNotifierProvider.value للحفاظ على نفس النسخة (Instance) بدون إنشاء واحدة جديدة
    return ChangeNotifierProvider.value(
      value: patientChatsViewModel,
      child: const _PatientChatsContent(),
    );
  }
}

class _PatientChatsContent extends StatelessWidget {
  const _PatientChatsContent();

  @override
  Widget build(BuildContext context) {
    // ✅ الآن لن يحدث خطأ لأن الشاشة مغلفة بالـ Provider الخاص بها
    final viewModel = Provider.of<PatientChatsViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const ChatSearchBar(),
              const SizedBox(height: 20),
              Expanded(
                child: viewModel.filteredChats.isEmpty
                    ? const Center(
                        child: Text(
                          "No chats found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: viewModel.filteredChats.length,
                        itemBuilder: (context, index) {
                          return ChatThreadCard(
                            chat: viewModel.filteredChats[index],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
