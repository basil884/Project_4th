import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/widget/info_card.dart';
import 'package:sugar_wise/features/patient/patient_profile/view/widget/profile_header.dart';
import 'package:sugar_wise/features/patient/patient_profile/view_models/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileViewModel _viewModel = ProfileViewModel();

  @override
  Widget build(BuildContext context) {
    final patient = _viewModel.patientData;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(patient: patient),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  InfoCard(
                    title: "Personal details",
                    data: {
                      "The Age": patient.age,
                      "Blood Group": patient.bloodType,
                      "Mail": patient.email,
                    },
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    title: "Medical history",
                    data: {
                      "Diagnosis": patient.diagnosis,
                      "Duration": patient.duration,
                      "Date of diagnosis": patient.diagnosisDate,
                    },
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    title: "Insulin system",
                    data: {
                      "Type": patient.insulinType,
                      "Dosage": patient.insulinDose,
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
