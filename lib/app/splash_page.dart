import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:agroconecta/data/datasource/local/local_storage_services.dart';
import 'package:agroconecta/app/routes.dart';

class SplashRedirectPage extends StatefulWidget {
  const SplashRedirectPage({super.key});

  @override
  State<SplashRedirectPage> createState() => _SplashRedirectPageState();
}

class _SplashRedirectPageState extends State<SplashRedirectPage> {
  final localStorageService = LocalStorageService();
  final authApi = AuthServices();
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      final token = await localStorageService.getValue('token');
      if (context.mounted) {
        if (token != null && token.isNotEmpty) {
          authApi.CarregarToken(token);
          Navigator.pushReplacementNamed(context, Routes.main);
        } else {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao verificar login: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Splash/loading
      ),
    );
  }
}
