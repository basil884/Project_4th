import 'package:flutter/material.dart';

class ThemeDropdown extends StatefulWidget {
  const ThemeDropdown({super.key});

  @override
  State<ThemeDropdown> createState() => _ThemeDropdownState();
}

class _ThemeDropdownState extends State<ThemeDropdown> {
  String selectedTheme = "Light Mode";

  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      height: 55, 
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC), 
        border: Border.all(color: const Color(0xffE2E8F0)), 
        borderRadius: BorderRadius.circular(12), 
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTheme,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xff64748B)),
          isExpanded: true, 
          style: const TextStyle(color: Color(0xff1E293B), fontSize: 15, fontWeight: FontWeight.w500),
          items: [
            _buildDropdownItem("Light Mode", Icons.wb_sunny_outlined, const Color(0xff3B82F6)),
            _buildDropdownItem("Dark Mode", Icons.nightlight_round, const Color(0xff6366F1)),
          ],
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedTheme = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, IconData icon, Color iconColor) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Text(value),
        ],
      ),
    );
  }
}