import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final String label;
  final List<DropdownMenuItem<String>>? items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownButton({
    Key? key,
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasItems = items != null && items!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: hasItems ? value : null,
          items: hasItems
              ? items
              : [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Nenhum item disponível'),
                  ),
                ],
          onChanged: hasItems ? onChanged : null,
          decoration: InputDecoration(
            hintText: hasItems ? 'Selecione...' : null,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}
