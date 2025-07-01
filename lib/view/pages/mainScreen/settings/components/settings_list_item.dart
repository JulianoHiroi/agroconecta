import 'package:flutter/material.dart';

class SettingsListItem extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const SettingsListItem({
    Key? key,
    required this.label,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Ícone à esquerda
            Image.asset(iconPath, width: 24, height: 24, color: Colors.black87),
            const SizedBox(width: 16),
            // Título
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
