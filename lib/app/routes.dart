import 'package:agroconecta/view/pages/home/home_page.dart';
import 'package:agroconecta/view/pages/login/login_pages.dart';
import 'package:agroconecta/view/pages/settings/settings.page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String settings = '/settings';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: const Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
