import 'package:flutter/material.dart';
import '../../models/patient_profile_model.dart';

// --- الكارت الأول: التفاصيل الشخصية ---
class PersonalDetailsCard extends StatelessWidget {
  final PatientProfileModel patient;

  const PersonalDetailsCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            Icons.person_outline,
            const Color(0xFFE65100),
            "Personal Details",
          ),
          const SizedBox(height: 15),
          _buildInfoRow("Age", patient.age),
          _buildInfoRow("Gender", patient.gender),
          _buildInfoRow("Blood Type", patient.bloodType, isBloodType: true),
          _buildInfoRow("Address", patient.address),
          _buildInfoRow("Phone", patient.phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBloodType = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
          ),
          isBloodType
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1D2939),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
        ],
      ),
    );
  }
}

// --- الكارت الثاني: التاريخ الطبي ---
class MedicalHistoryCard extends StatelessWidget {
  final PatientProfileModel patient;

  const MedicalHistoryCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            Icons.medical_information_outlined,
            const Color(0xFFE65100),
            "Medical History",
          ),
          const SizedBox(height: 20),

          // Primary Condition
          _buildSubLabel("PRIMARY CONDITION"),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  patient.primaryCondition,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D2939),
                    fontSize: 14,
                  ),
                ),
                Text(
                  patient.conditionDuration,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Insulin Regimen
          _buildSubLabel("INSULIN REGIMEN"),
          const SizedBox(height: 8),
          _buildBorderedBox("Basal", patient.basalInsulin),
          const SizedBox(height: 10),
          _buildBorderedBox("Bolus", patient.bolusInsulin),
          const SizedBox(height: 20),

          // Other Medications
          _buildSubLabel("OTHER MEDICATIONS"),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: patient.otherMedications
                .map((med) => _buildMedChip(med))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBorderedBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF667085), fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D2939),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1D2939),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// أداة مشتركة لرسم العنوان والأيقونة
Widget _buildSectionTitle(IconData icon, Color color, String title) {
  return Row(
    children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1D2939),
        ),
      ),
    ],
  );
}

Widget _buildSubLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      color: Color(0xFF667085),
    ),
  );
}
