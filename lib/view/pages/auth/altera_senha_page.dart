import 'package:agroconecta/data/datasource/local/local_storage_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/auth_services.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:agroconecta/view/widgets/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class AlteraSenhaPage extends StatefulWidget {
  const AlteraSenhaPage({super.key});

  @override
  State<AlteraSenhaPage> createState() => _AlteraSenhaPageState();
}

class _AlteraSenhaPageState extends State<AlteraSenhaPage> {
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  final authApi =
      AuthServices(); // Supondo que AuthServices esteja implementado
  final LocalStorageService localStorageService =
      LocalStorageService(); // Serviço para manipulação de armazenamento local

  @override
  void dispose() {
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> alterarSenha(String senha, String confirmarSenha) async {
    if (senha.isEmpty || confirmarSenha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem')));
      return;
    }
    var token = await localStorageService.getValue('token');
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Token inválido')));
      return;
    }
    // redireciona o usuário para a página de login

    var novaSenha = senhaController.text;
    // Aqui você deve chamar o serviço de alteração de senha
    authApi
        .alterarSenha(token, novaSenha)
        .then((response) {
          if (response.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Senha alterada com sucesso!')),
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao alterar senha')),
            );
          }
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao alterar senha: $error')),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Senha'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: senhaController,
              obscureText: true,
              label: 'Nova Senha',
              hintText: 'Digite sua nova senha',
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: confirmarSenhaController,
              obscureText: true,
              label: 'Confirmar Senha',
              hintText: 'Confirme sua nova senha',
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              label: 'Alterar Senha',
              onPressed: () {
                alterarSenha(
                  senhaController.text,
                  confirmarSenhaController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
