import 'package:agroconecta/view/pages/auth/altera_senha_page.dart';
import 'package:agroconecta/view/pages/auth/cadastro_page.dart';
import 'package:agroconecta/view/pages/auth/codigo_recuperacao_page.dart';
import 'package:agroconecta/view/pages/auth/recuperar_senha_page.dart';
import 'package:agroconecta/view/pages/auth/login_page.dart';
import 'package:agroconecta/view/pages/mainScreen/main_page.dart';
import 'package:agroconecta/view/pages/mainScreen/search/search_page.dart';
import 'package:agroconecta/view/pages/mainScreen/settings/estabelecimentos/create_estabelecimentos_page.dart';
import 'package:agroconecta/view/pages/mainScreen/settings/estabelecimentos/estabecimentos_page.dart';
import 'package:agroconecta/view/pages/mainScreen/settings/estabelecimentos/select_estabelecimento_page.dart';
import 'package:agroconecta/view/pages/mainScreen/settings/produtos/create_product_page.dart';
import 'package:agroconecta/view/pages/mainScreen/settings/produtos/products_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String login = '/';
  static const String main = '/main';
  static const String cadastro = '/register';
  static const String recuperarSenha = '/recover-password';
  static const String codigoRecuperacao = '/code-recovery';
  static const String alteraSenha = '/change-password';
  static const String estabelecimentos = '/establishments';
  static const String createEstabelecimento = '/create-establishment';
  static const String editEstabelecimentoPrefix =
      '/edit-establishment'; // sem :id aqui
  static const String produtos = '/products';
  static const String createProduto = '/create-product';

  static const String teste = '/teste';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name!);

    // Rota com id dinâmico
    if (settings.name!.startsWith(Routes.editEstabelecimentoPrefix)) {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
      return MaterialPageRoute(
        builder: (_) =>
            EditEstabelecimentoPage(idEstabelecimento: id ?? 'erro'),
      );
    }

    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case Routes.cadastro:
        return MaterialPageRoute(builder: (_) => const CadastroPage());
      case Routes.recuperarSenha:
        return MaterialPageRoute(builder: (_) => const RecuperarSenhaPage());
      case Routes.codigoRecuperacao:
        return MaterialPageRoute(builder: (_) => const CodigoRecuperacaoPage());
      case Routes.alteraSenha:
        return MaterialPageRoute(builder: (_) => const AlteraSenhaPage());
      case Routes.estabelecimentos:
        return MaterialPageRoute(builder: (_) => const EstabecimentosPage());
      case Routes.createEstabelecimento:
        return MaterialPageRoute(
          builder: (_) => const CreateEstabelecimentoPage(),
        );
      case Routes.produtos:
        return MaterialPageRoute(builder: (_) => const ProductsPage());
      case Routes.teste:
        return MaterialPageRoute(builder: (_) => const SearchMapPage());
      case Routes.createProduto:
        return MaterialPageRoute(builder: (_) => const CreateProductPage());
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
