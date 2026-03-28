import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/features/auth/register/patient_registration/view_models/patient_registration_view_model.dart';

class PatientRegistrationView extends StatelessWidget {
  const PatientRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PatientRegistrationViewModel(),
      child: const _RegistrationContent(),
    );
  }
}

class _RegistrationContent extends StatelessWidget {
  const _RegistrationContent();

  final Color primaryGreen = const Color(0xFF00C897);
  final Color darkText = const Color(0xFF1D2939);
  final Color lightGray = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PatientRegistrationViewModel>(context);

    // ✅ السحر هنا: وضعنا الفورمات في قائمة لنعرض واحدة منها فقط
    final List<Widget> stepForms = [
      _buildStep1Form(context, viewModel),
      _buildStep2Form(context, viewModel),
      _buildStep3Form(context, viewModel),
      _buildStep4Form(context, viewModel),
    ];

    return Scaffold(
      backgroundColor: lightGray,
      body: SafeArea(
        // ✅ تم حذف PageView تماماً واستخدام التخطيط المشترك مرة واحدة
        child: _buildSharedLayout(
          context: context,
          viewModel: viewModel,
          // التبديل بين الفورمات يتم هنا بنعومة
          formCard: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              // الـ key ضروري لكي يعمل الأنيميشن
              key: ValueKey<int>(viewModel.currentIndex),
              child: stepForms[viewModel.currentIndex],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. التخطيط المشترك
  // ==========================================
  Widget _buildSharedLayout({
    required BuildContext context,
    required PatientRegistrationViewModel viewModel,
    required Widget formCard,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_add_alt_1, color: primaryGreen, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            "Create Patient Profile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Complete your profile in 4 simple steps",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 30),
          _buildDynamicStepper(viewModel.currentIndex),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: formCard,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // كارت الخطوة 1
  // ==========================================
  Widget _buildStep1Form(
    BuildContext context,
    PatientRegistrationViewModel viewModel,
  ) {
    return Form(
      key: viewModel.formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tell us about yourself",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: "First Name *",
                  hint: "John",
                  controller: viewModel.firstNameCtrl,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: "Last Name *",
                  hint: "Doe",
                  controller: viewModel.lastNameCtrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Gender *",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption("Male", Icons.male, viewModel),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderOption("Female", Icons.female, viewModel),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: "Birthday *",
            hint: "mm/dd/yyyy",
            controller: viewModel.birthdayCtrl,
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(primary: primaryGreen),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                viewModel.birthdayCtrl.text =
                    "${picked.month}/${picked.day}/${picked.year}";
              }
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: "Phone Number *",
            hint: "1XXXXXXXXX",
            controller: viewModel.phoneCtrl,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 30),
          _buildPrimaryButton(
            text: "Next",
            icon: Icons.arrow_forward,
            onPressed: viewModel.nextStep,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // كارت الخطوة 2
  // ==========================================
  Widget _buildStep2Form(
    BuildContext context,
    PatientRegistrationViewModel viewModel,
  ) {
    return Form(
      key: viewModel.formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Create your login credentials",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            label: "Email Address *",
            hint: "john.doe@example.com",
            controller: viewModel.emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: "Password *",
            hint: "••••••••",
            controller: viewModel.passwordCtrl,
            isObscured: viewModel.isPasswordObscured,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.isPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: viewModel.togglePasswordVisibility,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: "Confirm Password *",
            hint: "••••••••",
            controller: viewModel.confirmPasswordCtrl,
            isObscured: viewModel.isConfirmPasswordObscured,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (value != viewModel.passwordCtrl.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.isConfirmPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: viewModel.toggleConfirmPasswordVisibility,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildPreviousButton(onPressed: viewModel.previousStep),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPrimaryButton(
                  text: "Next",
                  icon: Icons.arrow_forward,
                  onPressed: viewModel.nextStep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // كارت الخطوة 3
  // ==========================================
  Widget _buildStep3Form(
    BuildContext context,
    PatientRegistrationViewModel viewModel,
  ) {
    final List<String> governorates = [
      'Cairo',
      'Alexandria',
      'Giza',
      'Qalyubia',
      'Faiyum',
    ];
    return Form(
      key: viewModel.formKeyStep3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Address Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Where can we reach you?",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            label: "Full Address *",
            hint: "Building number, street...",
            controller: viewModel.fullAddressCtrl,
            prefixIcon: Icons.location_on_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          _buildDropdownField(
            label: "Governorate *",
            hint: "Select governorate",
            prefixIcon: Icons.map_outlined,
            value: viewModel.selectedGovernorate,
            items: governorates,
            onChanged: viewModel.setGovernorate,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: "City *",
            hint: "Enter your city",
            controller: viewModel.cityCtrl,
            prefixIcon: Icons.location_city_outlined,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildPreviousButton(onPressed: viewModel.previousStep),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPrimaryButton(
                  text: "Next",
                  icon: Icons.arrow_forward,
                  onPressed: viewModel.nextStep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // كارت الخطوة 4
  // ==========================================
  Widget _buildStep4Form(
    BuildContext context,
    PatientRegistrationViewModel viewModel,
  ) {
    return Form(
      key: viewModel.formKeyStep4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Health Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Help us understand your health needs",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: "Weight (kg) *",
                  hint: "70",
                  controller: viewModel.weightCtrl,
                  prefixIcon: Icons.scale_outlined,
                  keyboardType: TextInputType.number,
                  suffixWidget: _buildSuffixText("kg"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: "Height (cm) *",
                  hint: "170",
                  controller: viewModel.heightCtrl,
                  prefixIcon: Icons.straighten_outlined,
                  keyboardType: TextInputType.number,
                  suffixWidget: _buildSuffixText("cm"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "MEDICAL CONDITIONS",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: darkText,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _buildConditionCard(
                "Diabetes",
                Icons.vaccines_outlined,
                viewModel,
              ),
              _buildConditionCard(
                "High Blood Pressure",
                Icons.monitor_heart_outlined,
                viewModel,
              ),
              _buildConditionCard(
                "Heart Disease",
                Icons.favorite_border_outlined,
                viewModel,
              ),
              _buildConditionCard(
                "Kidney Disease",
                Icons.water_drop_outlined,
                viewModel,
              ),
              _buildConditionCard(
                "Thyroid Disorders",
                Icons.medical_services_outlined,
                viewModel,
              ),
              _buildConditionCard("Asthma", Icons.air_outlined, viewModel),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildPreviousButton(onPressed: viewModel.previousStep),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: _buildPrimaryButton(
                  text: "Complete Profile",
                  icon: Icons.check_circle,
                  onPressed: () => viewModel.submitRegistration(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // دوال مساعدة (Helpers)
  // ==========================================

  Widget _buildDynamicStepper(int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepItem(
          "1",
          "Personal Info",
          currentIndex >= 0,
          currentIndex > 0,
        ),
        _buildStepDivider(currentIndex >= 1),
        _buildStepItem("2", "Account", currentIndex >= 1, currentIndex > 1),
        _buildStepDivider(currentIndex >= 2),
        _buildStepItem("3", "Address", currentIndex >= 2, currentIndex > 2),
        _buildStepDivider(currentIndex >= 3),
        _buildStepItem("4", "Health", currentIndex >= 3, false),
      ],
    );
  }

  Widget _buildStepItem(
    String step,
    String title,
    bool isActive,
    bool isCompleted,
  ) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isCompleted || isActive ? primaryGreen : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? primaryGreen : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : Text(
                  step,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: isActive ? primaryGreen : Colors.grey.shade400,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      color: isActive ? primaryGreen : Colors.grey.shade300,
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    TextEditingController? controller,
    bool isObscured = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
    Widget? suffixWidget,
    VoidCallback? onTap,
    bool readOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isObscured,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator:
              validator ??
              (value) => value == null || value.isEmpty ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: maxLines > 1 ? (maxLines * 15.0) - 20 : 0,
                    ),
                    child: Icon(
                      prefixIcon,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                  )
                : null,
            suffixIcon: suffixIcon ?? suffixWidget,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value:
              value, // ❌ تم استبدال initialValue بـ value لأن هذا هو الصحيح هنا
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, color: Colors.grey.shade400, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryGreen),
            ),
          ),
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          validator: (val) => val == null ? 'Required' : null,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSuffixText(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 14),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildConditionCard(
    String title,
    IconData icon,
    PatientRegistrationViewModel viewModel,
  ) {
    bool isSelected = viewModel.selectedConditions.contains(title);
    return GestureDetector(
      onTap: () => viewModel.toggleCondition(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryGreen.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryGreen : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? primaryGreen : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(
    String title,
    IconData icon,
    PatientRegistrationViewModel viewModel,
  ) {
    bool isSelected = viewModel.gender == title;
    return GestureDetector(
      onTap: () => viewModel.setGender(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryGreen.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryGreen : Colors.grey.shade500,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? primaryGreen : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ تم تحديث زر الأساسي ليقوم بتصغير محتواه تلقائياً في الشاشات الصغيرة
  Widget _buildPrimaryButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ), // تقليل الحواف الداخلية لزيادة المساحة للنص
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // ✅ إضافة السحر هنا (FittedBox)
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 6,
              ), // تقليل المسافة بين النص والأيقونة قليلاً
              Icon(icon, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ تم تحديث زر العودة ليقوم بتصغير محتواه أيضاً
  Widget _buildPreviousButton({required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: darkText,
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // ✅ إضافة السحر هنا (FittedBox)
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_back, size: 16),
              const SizedBox(width: 6),
              const Text(
                "Previous",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
