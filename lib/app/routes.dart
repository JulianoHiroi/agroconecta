import 'package:agroconecta/view/pages/auth/altera_senha_page.dart';
import 'package:agroconecta/view/pages/auth/cadastro_page.dart';
import 'package:agroconecta/view/pages/auth/codigo_recuperacao_page.dart';
import 'package:agroconecta/view/pages/auth/recuperar_senha_page.dart';
import 'package:agroconecta/view/pages/home/home_page.dart';
import 'package:agroconecta/view/pages/auth/login_page.dart';
import 'package:agroconecta/view/pages/settings/settings.page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String cadastro = '/register';
  static const String recuperarSenha = '/recover-password';
  static const String codigoRecuperacao = '/code-recovery';
  static const String alteraSenha = '/change-password';
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
      case Routes.cadastro:
        return MaterialPageRoute(builder: (_) => const CadastroPage());
      case Routes.recuperarSenha:
        return MaterialPageRoute(builder: (_) => const RecuperarSenhaPage());
      case Routes.codigoRecuperacao:
        // Aqui você pode passar argumentos se necessário
        return MaterialPageRoute(builder: (_) => const CodigoRecuperacaoPage());
      case Routes.alteraSenha:
        return MaterialPageRoute(builder: (_) => const AlteraSenhaPage());
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
