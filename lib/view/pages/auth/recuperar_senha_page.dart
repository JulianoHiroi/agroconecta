import 'package:agroconecta/data/datasource/local/local_storage_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/auth_services.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:agroconecta/view/widgets/components/custom_text_field.dart';
import 'package:agroconecta/view/widgets/logo/logo.widget.dart';
import 'package:flutter/material.dart';

class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({Key? key}) : super(key: key);

  @override
  _RecuperarSenhaPageState createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  final TextEditingController emailController = TextEditingController();

  final authApi = AuthServices();
  final LocalStorageService localStorageService = LocalStorageService();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void recuperarSenha(String email) {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu email')),
      );
      return;
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email inválido')));
      return;
    }
    // Chama o serviço de recuperação de senha
    authApi
        .recuperarSenha(email)
        .then((response) {
          if (response.success) {
            // Redireciona o usuário para a pagina de colcoar o código de recuperação
            localStorageService.setValue('emailRecuperacao', email);
            Navigator.pushNamed(context, '/code-recovery', arguments: email);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email de recuperação enviado com sucesso!'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao enviar email de recuperação'),
              ),
            );
          }
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao enviar email: $error')),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(),
            SizedBox(height: 60),
            // Apresente um informativo sobre a recuperação de senha
            const Text(
              'Digite seu email para receber instruções de recuperação de senha.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            CustomTextField(
              controller: emailController,
              label: 'Email',
              hintText: 'Digite seu email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              alignment: Alignment.bottomRight,
              child: CustomElevatedButton(
                label: 'Enviar',
                width: 100,
                onPressed: () {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, insira seu email'),
                      ),
                    );
                    return;
                  }

                  recuperarSenha(emailController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
