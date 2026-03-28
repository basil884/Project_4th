import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/appearance_theme/apperance_card.dart';
import 'package:sugar_wise/features/patient/appearance_theme/model/apperance_models.dart';
import 'package:sugar_wise/features/patient/notfications/notifactions_edit/view/notifaction_edit.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingModel> otherSettings = [
      SettingModel(
        title: "Notifications",
        AssetImage: "assets/images/apperance/Container.png",
        iconColor: Colors.orange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Notifications()),
          );
        },
      ),
      SettingModel(
        title: "Privacy & Security",
        AssetImage: "assets/images/apperance/Iconc.png",
        iconColor: Colors.teal,
        onTap: () {
          print("Privacy Tapped");
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xff1E293B),
            size: 20,
          ),
        ),
        title: const Text(
          "Appearance & Theme",
          style: TextStyle(
            color: Color(0xff1E293B),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Appearance & Theme",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            const AppearanceCard(),
            const SizedBox(height: 35),
            const Text(
              "OTHER SETTINGS",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 15),

            ...otherSettings
                .map((setting) => SettingsItem(model: setting))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final SettingModel model;
  const SettingsItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: model.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                model.AssetImage,
                width: 22,
                height: 22,
                color: model.iconColor,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, color: model.iconColor),
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Text(
                model.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1E293B),
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
