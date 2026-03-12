import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_profile/models/patient_profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  // بيانات افتراضية للمريض (Mock Data)
  final PatientProfileModel patientData = PatientProfileModel(
    name: "Ahmed Mohamed",
    role: "Patient",
    imageUrl: 'assets/images/doctor/doc3.jpg',
    age: "12 age",
    bloodType: "A+",
    email: "info@gmail.com",
    diagnosis: "Type 1 Diabetes",
    duration: "4 Years",
    diagnosisDate: "15-03-2020",
    insulinType: "Lantus (Basal)",
    insulinDose: "Info 2 :Info sip",
  );

  // إذا كان هناك أي منطق آخر للصفحة (مثل جلب البيانات من API) نضعه هنا
}
