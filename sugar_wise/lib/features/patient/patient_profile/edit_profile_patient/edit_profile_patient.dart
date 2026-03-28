import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; // ✅ مكتبة الموقع
import 'package:geocoding/geocoding.dart'; // ✅ مكتبة تحويل الموقع لعنوان
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

class EditProfile extends StatefulWidget {
  final ProfileViewModel viewModel;

  const EditProfile({super.key, required this.viewModel});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController ageCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController weightCtrl;
  late TextEditingController conditionCtrl;
  late TextEditingController durationCtrl;

  String selectedGender = "Male";
  String selectedBloodType = "A+";
  String selectedBasal = "Lantus";
  String selectedBolus = "Novorapid";

  File? _pickedImage;

  // ✅ متغير للتحكم في ظهور دائرة التحميل أثناء جلب الموقع
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    final patient = widget.viewModel.patientData;

    ageCtrl = TextEditingController(
      text: patient.age.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    phoneCtrl = TextEditingController(text: patient.phone);
    emailCtrl = TextEditingController(text: "ahmed.m@example.com");
    addressCtrl = TextEditingController(text: patient.address);
    heightCtrl = TextEditingController(text: patient.height);
    weightCtrl = TextEditingController(text: patient.weight);
    conditionCtrl = TextEditingController(text: patient.primaryCondition);
    durationCtrl = TextEditingController(
      text: patient.conditionDuration.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    selectedGender = ["Male", "Female"].contains(patient.gender)
        ? patient.gender
        : "Male";
    selectedBloodType =
        [
          "A+",
          "A-",
          "B+",
          "B-",
          "O+",
          "O-",
          "AB+",
          "AB-",
        ].contains(patient.bloodType)
        ? patient.bloodType
        : "A+";
    selectedBasal = patient.basalInsulin.isNotEmpty
        ? patient.basalInsulin
        : "Lantus";
    selectedBolus = patient.bolusInsulin.isNotEmpty
        ? patient.bolusInsulin
        : "Novorapid";
  }

  @override
  void dispose() {
    ageCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    heightCtrl.dispose();
    weightCtrl.dispose();
    conditionCtrl.dispose();
    durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  // 🔥 السحر هنا: دالة جلب الموقع الحالي وتحويله لعنوان نصي
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true); // تشغيل دائرة التحميل

    try {
      // 1. التأكد من أن الـ GPS يعمل
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }

      // 2. طلب صلاحية الموقع من المستخدم
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      // 3. جلب الإحداثيات الحالية (طول وعرض)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. تحويل الإحداثيات إلى اسم شارع ومدينة
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // تجميع العنوان بشكل أنيق (مثال: Al-Maadi, Cairo, Egypt)
        String address =
            "${place.street != null && place.street!.isNotEmpty ? '${place.street}, ' : ''}${place.locality ?? place.subAdministrativeArea}, ${place.country}";

        // تحديث حقل النص مباشرة
        setState(() {
          addressCtrl.text = address;
        });
      }
    } catch (e) {
      // إظهار رسالة خطأ إذا رفض المستخدم أو حدثت مشكلة
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoadingLocation = false); // إيقاف التحميل
    }
  }

  void _saveChanges() {
    widget.viewModel.updateProfile(
      newName: widget.viewModel.patientData.name,
      newPhone: phoneCtrl.text.trim(),
      newImagePath: _pickedImage?.path,
      newAge: "${ageCtrl.text.trim()} Years",
      newGender: selectedGender,
      newBloodType: selectedBloodType,
      newAddress: addressCtrl.text.trim(),
      newHeight: heightCtrl.text.trim(),
      newWeight: weightCtrl.text.trim(),
      newCondition: conditionCtrl.text.trim(),
      newDuration: "Since ${durationCtrl.text.trim()} Years",
      newBasal: selectedBasal,
      newBolus: selectedBolus,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.viewModel.patientData;

    ImageProvider getImageProvider() {
      if (_pickedImage != null) return FileImage(_pickedImage!);
      if (patient.imageUrl.startsWith('assets/')) {
        return AssetImage(patient.imageUrl);
      }
      return FileImage(File(patient.imageUrl));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Edit Profile Patient",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
        leadingWidth: 90,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: getImageProvider(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID: ${patient.patientId}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildSectionHeader(Icons.person_outline, "Personal Details"),
              _buildLabelAndField("Age", _buildTextField(ageCtrl)),
              _buildLabelAndField(
                "Gender",
                _buildDropdown(selectedGender, [
                  "Male",
                  "Female",
                ], (val) => setState(() => selectedGender = val!)),
              ),
              _buildLabelAndField(
                "Blood Type",
                _buildDropdown(
                  selectedBloodType,
                  ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
                  (val) => setState(() => selectedBloodType = val!),
                ),
              ),
              _buildLabelAndField("Phone", _buildTextField(phoneCtrl)),
              _buildLabelAndField("Email", _buildTextField(emailCtrl)),

              // ✅ حقل العنوان مع أيقونة الـ GPS الذكية
              _buildLabelAndField(
                "Address",
                _buildTextField(
                  addressCtrl,
                  suffixIcon: _isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.deepOrange,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.my_location,
                            color: Colors.deepOrange,
                          ),
                          onPressed: _getCurrentLocation,
                          tooltip: "Get Current Location",
                        ),
                ),
              ),

              const SizedBox(height: 10),

              _buildSectionHeader(Icons.monitor_weight_outlined, "Vitals"),
              Row(
                children: [
                  Expanded(
                    child: _buildLabelAndField(
                      "Height (cm)",
                      _buildTextField(heightCtrl),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildLabelAndField(
                      "Weight (kg)",
                      _buildTextField(weightCtrl),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _buildSectionHeader(
                Icons.history_edu_outlined,
                "Medical History",
              ),
              _buildLabelAndField(
                "Primary Condition",
                _buildTextField(conditionCtrl),
              ),
              _buildLabelAndField(
                "Years of illness",
                _buildTextField(durationCtrl),
              ),
              const SizedBox(height: 10),

              _buildSectionHeader(Icons.vaccines_outlined, "Insulin Regimen"),
              _buildLabelAndField(
                "First Insulin (Basal)",
                _buildDropdown(selectedBasal, [
                  "Lantus",
                  "Levemir",
                  "Tresiba",
                  "Toujeo",
                ], (val) => setState(() => selectedBasal = val!)),
              ),
              _buildLabelAndField(
                "Second Insulin (Bolus)",
                _buildDropdown(selectedBolus, [
                  "Novorapid",
                  "Humalog",
                  "Apidra",
                  "Fiasp",
                ], (val) => setState(() => selectedBolus = val!)),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader(
                    Icons.medication_outlined,
                    "Other Medications",
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "+ Add Medication",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildMedicationCard("Metformin", "Oral Tablet", "Twice daily"),
              _buildMedicationCard(
                "Atorvastatin",
                "Oral Tablet",
                "Every night",
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Discard Changes",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.deepOrange,
                        elevation: 0,
                      ),
                      child: const Text(
                        "Save & Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelAndField(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          field,
        ],
      ),
    );
  }

  // ✅ تم تحديث أداة بناء الـ TextField لتقبل أيقونة إضافية
  Widget _buildTextField(
    TextEditingController controller, {
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange),
        ),
        suffixIcon: suffixIcon, // 👈 استقبال الأيقونة هنا
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildMedicationCard(String name, String type, String frequency) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "NAME",
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "TYPE",
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                type,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "FREQUENCY",
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                frequency,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
          const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
