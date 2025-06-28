// faça uma pagina de login que será a primeira página do app
// Ela conterá 2 inputs de email e senha, um botão de login e um botão de cadastro
// E terá um botão de "Esqueci minha senha" que levará para uma página de recuperação de senha
// E terá um botão para a tela de cadastro

import 'package:agroconecta/data/datasource/local/local_storage_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/auth_services.dart';
import 'package:agroconecta/data/datasource/local/repositories/user.reposiroty.dart';
import 'package:agroconecta/view/utils/exception-utils.dart';
import 'package:agroconecta/view/widgets/logo/logo.widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final authApi = AuthServices();
  final localStorageService = LocalStorageService();
  final UserRepository userRepository = UserRepository();

  void fazerLogin(String email, String password) async {
    handleAsync(
      context: context,
      operation: () async {
        //final response = await authApi.login(email, password);
        final response = await authApi.login(
          "teste@teste.com",
          "SenhaForte123!",
        );
        if (response.token.isNotEmpty) {
          // Armazenar o token no armazenamento local
          await localStorageService.setValue('token', response.token);
          // Armazenar o usuário no armazenamento local
          await userRepository.insertUser(response.user);
          // Navegar para a página inicial
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login falhou.')));
        }
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fazerLogin(emailController.text, passwordController.text);
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navegar para a página de recuperação de senha
                Navigator.pushNamed(context, '/recover-password');
              },
              child: const Text('Esqueci minha senha'),
            ),
            TextButton(
              onPressed: () {
                // Navegar para a página de cadastro
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Cadastrar-se'),
            ),
          ],
        ),
      ),
    );
  }
}
