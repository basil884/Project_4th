import 'package:flutter/material.dart';

class LanguageItem extends StatelessWidget {
  final String name;
  final String nativeName;
  final String code;
  final bool selected;

  const LanguageItem({
    required this.name,
    required this.nativeName,
    required this.code,
    required this.selected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xffEFF6FF).withOpacity(0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        leading: SizedBox(
          width: 60,
          child: Row(
            children: [
              Text(
                code,
                style: const TextStyle(
                  color: Color(0xff5D5FEF),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),

        title: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: selected ? Colors.blue.shade700 : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.blue.withOpacity(0.1)
                    : const Color(0xffF3E5F5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                code,
                style: TextStyle(
                  color: selected ? Colors.blue : Colors.purple.shade400,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          nativeName,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        trailing: selected
            ? const Icon(Icons.check_circle, color: Colors.blue, size: 24)
            : null,
      ),
    );
  }
}
