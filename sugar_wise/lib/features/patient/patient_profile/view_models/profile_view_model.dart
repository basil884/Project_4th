import 'package:flutter/material.dart';
import '../models/patient_profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  // ✅ أزلنا كلمة final لكي نتمكن من تعديل البيانات
  PatientProfileModel patientData = PatientProfileModel(
    name: "Ahmed Mohamed",
    imageUrl: "assets/images/patient_avatar.png",
    patientId: "SW-4029",
    height: "145",
    weight: "38",
    age: "12 Years",
    gender: "Male",
    bloodType: "A+",
    address: "Al-Maadi, Cairo, Egypt",
    phone: "+20 123 456 7890",
    primaryCondition: "Type 1 Diabetes",
    conditionDuration: "Since 4 Years",
    basalInsulin: "Lantus",
    bolusInsulin: "Novorapid",
    otherMedications: ["Vitamin D3", "Multivitamin"],
  );

  // ✅ دالة جديدة لحفظ التعديلات وتحديث الواجهات
  // ✅ أضفنا مسار الصورة كمتغير اختياري
  // ✅ دالة الحفظ الشاملة لكل حقول البروفايل
  void updateProfile({
    required String newName,
    required String newPhone,
    String? newImagePath,
    required String newAge,
    required String newGender,
    required String newBloodType,
    required String newAddress,
    required String newHeight,
    required String newWeight,
    required String newCondition,
    required String newDuration,
    required String newBasal,
    required String newBolus,
  }) {
    patientData = PatientProfileModel(
      name: newName, // يمكنك جعل الاسم قابلاً للتعديل إذا أردت
      phone: newPhone,
      imageUrl: newImagePath ?? patientData.imageUrl,
      patientId: patientData.patientId, // الـ ID عادة لا يتغير
      age: newAge,
      gender: newGender,
      bloodType: newBloodType,
      address: newAddress,
      height: newHeight,
      weight: newWeight,
      primaryCondition: newCondition,
      conditionDuration: newDuration,
      basalInsulin: newBasal,
      bolusInsulin: newBolus,
      otherMedications: patientData.otherMedications,
    );

    notifyListeners();
  }
}
