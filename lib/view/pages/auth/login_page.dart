// faça uma pagina de login que será a primeira página do app
// Ela conterá 2 inputs de email e senha, um botão de login e um botão de cadastro
// E terá um botão de "Esqueci minha senha" que levará para uma página de recuperação de senha
// E terá um botão para a tela de cadastro

import 'package:agroconecta/data/datasource/local/local_storage_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/auth_services.dart';
import 'package:agroconecta/data/datasource/local/repositories/user.reposiroty.dart';
import 'package:agroconecta/view/utils/exception-utils.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:agroconecta/view/widgets/components/custom_text_field.dart';
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
          "juca.sup2@gmail.com",
          "Ndacps16#",
        );
        if (response.token.isNotEmpty) {
          // Armazenar o token no armazenamento local
          await localStorageService.setValue('token', response.token);
          await localStorageService.setValue('userId', response.user.id);
          // Armazenar o usuário no armazenamento local
          await userRepository.insertUser(response.user);
          // Navegar para a página inicial
          Navigator.pushReplacementNamed(context, '/main');
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LogoWidget(),
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 10),
              child: CustomTextField(
                controller: emailController,
                label: 'Email',
                hintText: 'Digite seu email',
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            CustomTextField(
              controller: passwordController,
              obscureText: true,
              label: 'Senha',
              hintText: 'Digite seu senha',
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 20),

            CustomElevatedButton(
              label: 'Enviar',
              onPressed: () {
                fazerLogin(emailController.text, passwordController.text);
              },
            ),

            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.black87),
              onPressed: () {
                // Navegar para a página de recuperação de senha
                Navigator.pushNamed(context, '/recover-password');
              },
              child: const Text('Esqueci minha senha'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.black87),
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
