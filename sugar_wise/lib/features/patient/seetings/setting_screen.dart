import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/patient/appearance_theme/apperance_screen.dart';
import 'package:sugar_wise/features/patient/helpsupport/helpsupport_screen.dart';
import 'package:sugar_wise/features/patient/language_screen/view/language_screen.dart';
import 'package:sugar_wise/features/patient/mobile_billing_plans/view/biling_extends.dart';
// تأكد من صحة هذه المسارات لديك
import 'package:sugar_wise/features/patient/notfications/notifactions_edit/view/notifaction_edit.dart';
import 'package:sugar_wise/features/patient/patient_profile/edit_profile_patient/edit_profile_patient.dart';
import 'package:sugar_wise/features/patient/seetings/securty_set/securty_seting_patient.dart';
import 'package:sugar_wise/features/patient/seetings/settings_view_model.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

// ✅ كلاس واحد فقط بدون أي تغليف (ChangeNotifierProvider تم حذفه من هنا)
class SettingsScreenPatient extends StatelessWidget {
  const SettingsScreenPatient({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ نقرأ العقل المدبر الخاص بالإعدادات مباشرة (لأنه موجود الآن في main.dart)
    final viewModel = Provider.of<SettingsViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFE64A19),
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(title: "ACCOUNT & SECURITY"),
              _CustomSettingsItem(
                icon: Icons.person_outline,
                iconColor: Colors.blue,
                iconBgColor: Colors.blue.withValues(alpha: 0.1),
                title: "Edit Profile",
                isSelected: viewModel.selectedIndex == 0,
                onTap: () => viewModel.selectItem(0, () {
                  // ✅ جلب عقل البروفايل (ProfileViewModel) من التطبيق وإرساله للشاشة
                  final profileViewModel = Provider.of<ProfileViewModel>(
                    context,
                    listen: false,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfile(viewModel: profileViewModel),
                    ),
                  );
                }),
              ),
              _CustomSettingsItem(
                icon: Icons.notifications_none_outlined,
                iconColor: Colors.orange,
                iconBgColor: Colors.orange.withValues(alpha: 0.1),
                title: "Notifications",
                isSelected: viewModel.selectedIndex == 1,
                onTap: () => viewModel.selectItem(1, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                }),
              ),
              _CustomSettingsItem(
                icon: Icons.security_outlined,
                iconColor: Colors.green,
                iconBgColor: Colors.green.withValues(alpha: 0.1),
                title: "Security Settings",
                isSelected: viewModel.selectedIndex == 2,
                onTap: () => viewModel.selectItem(2, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecurtySettingPatient(),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),
              const _SectionHeader(title: "PREFERENCES"),
              _CustomSettingsItem(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Colors.purple,
                iconBgColor: Colors.purple.withValues(alpha: 0.1),
                title: "Billing & Plans",
                isSelected: viewModel.selectedIndex == 3,
                onTap: () => viewModel.selectItem(3, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Billing()),
                  );
                }),
              ),
              _CustomSettingsItem(
                icon: Icons.color_lens_outlined,
                iconColor: Colors.pink,
                iconBgColor: Colors.pink.withValues(alpha: 0.1),
                title: "Appearance & Theme",
                isSelected: viewModel.selectedIndex == 4,
                onTap: () => viewModel.selectItem(4, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppearanceScreen()),
                  );
                }),
              ),
              _CustomSettingsItem(
                icon: Icons.language_outlined,
                iconColor: Colors.blueAccent,
                iconBgColor: Colors.blueAccent.withValues(alpha: 0.1),
                title: "Language Settings",
                isSelected: viewModel.selectedIndex == 5,
                onTap: () => viewModel.selectItem(5, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguageScreen()),
                  );
                }),
              ),

              const SizedBox(height: 24),
              const _SectionHeader(title: "SUPPORT"),
              _CustomSettingsItem(
                icon: Icons.help_outline,
                iconColor: Colors.orangeAccent,
                iconBgColor: Colors.orangeAccent.withValues(alpha: 0.1),
                title: "Help & Support",
                isSelected: viewModel.selectedIndex == 6,
                onTap: () => viewModel.selectItem(6, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpSupportScreen(),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),
              _buildLogoutButton(context, viewModel),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "App Version 1.0.0",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, SettingsViewModel viewModel) {
    return InkWell(
      onTap: () => viewModel.logout(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Color(0xFFE53935), size: 20),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomSettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomSettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xff2F66D0) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.2)
                : iconBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isSelected ? Colors.white : Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black.withValues(alpha: 0.9),
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
