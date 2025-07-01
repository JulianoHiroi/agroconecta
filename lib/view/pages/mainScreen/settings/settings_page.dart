import 'package:agroconecta/view/pages/mainScreen/settings/components/settings_list_item.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'label': 'Configurações de Usuário',
        'icon': 'assets/icons/user_profile.png',
        'route': '/user-settings',
      },
      {
        'label': 'Estabelecimentos',
        'icon': 'assets/icons/location.png',
        'route': '/establishments',
      },
      {
        'label': 'Produtos',
        'icon': 'assets/icons/products.png',
        'route': '/products',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: items.length + 1,
          separatorBuilder: (_, __) =>
              const Divider(height: 2, thickness: 1, color: Colors.grey),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configurações',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }

            final item = items[index - 1];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SettingsListItem(
                label: item['label']!,
                iconPath: item['icon']!,
                onTap: () => Navigator.pushNamed(context, item['route']!),
              ),
            );
          },
        ),
      ),
    );
  }
}
