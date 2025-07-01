import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final items = [
      {'icon': 'search.png', 'label': 'Pesquisar'},
      {'icon': 'message.png', 'label': 'Mensagem'},
      {'icon': 'cart.png', 'label': 'Pedidos'},
      {'icon': 'settings.png', 'label': 'Menu'},
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(0, 12, 0, bottomPadding + 12),
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final selected = index == currentIndex;
          return GestureDetector(
            onTap: () => onItemTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Image.asset(
                    'assets/icons/${items[index]['icon']}',
                    width: 24,
                    height: 24,
                    color: selected ? Colors.black : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items[index]['label']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: selected ? Colors.black : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
