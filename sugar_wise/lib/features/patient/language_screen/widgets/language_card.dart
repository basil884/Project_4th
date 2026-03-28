import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/language_screen/widgets/langue_item.dart';

class LanguageCard extends StatefulWidget {
  const LanguageCard({super.key});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  String selectedLanguage = "Arabic";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xff2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/languagem/languagem.png',
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Language Settings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            "Select your preferred language for the interface.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: InputDecoration(
              hintText: "Search languages...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xffF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xffE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xffE2E8F0)),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildLanguageOption("English", "English", "EN"),
                _buildLanguageOption("Arabic", "العربية", "AR"),
                _buildLanguageOption("French", "Français", "FR"),
                _buildLanguageOption("German", "Deutsch", "DE"),
                _buildLanguageOption("Spanish", "Español", "ES"),
                _buildLanguageOption("Turkish", "Türkçe", "TR"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() => selectedLanguage = "Arabic");
                },
                child: const Text(
                  "Reset",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String name, String nativeName, String code) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = name;
        });
      },
      child: LanguageItem(
        name: name,
        nativeName: nativeName,
        code: code,
        selected: selectedLanguage == name,
      ),
    );
  }
}
