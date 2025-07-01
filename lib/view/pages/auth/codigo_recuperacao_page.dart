import 'package:agroconecta/data/datasource/local/local_storage_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/auth_services.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:agroconecta/view/widgets/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class CodigoRecuperacaoPage extends StatefulWidget {
  const CodigoRecuperacaoPage({super.key});

  @override
  _CodigoRecuperacaoPageState createState() => _CodigoRecuperacaoPageState();
}

class _CodigoRecuperacaoPageState extends State<CodigoRecuperacaoPage> {
  final TextEditingController codigoController = TextEditingController();

  final authApi =
      AuthServices(); // Supondo que AuthServices esteja implementado

  final LocalStorageService localStorageService =
      LocalStorageService(); // Serviço para manipulação de armazenamento local

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  Future<void> verificarCodigo(String codigo) async {
    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o código')),
      );
      return;
    }
    // Aqui você deve chamar o serviço de verificação do código
    var emailRecuperacao = await localStorageService.getValue(
      'emailRecuperacao',
    );
    if (emailRecuperacao == null || emailRecuperacao.isEmpty) {
      // Redireciona para a pagina de recuperação de senha
      Navigator.pushNamed(context, '/recover-password');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: Email de recuperação não encontrado'),
        ),
      );
      return;
    }

    authApi
        .verificarCodigo(codigo, emailRecuperacao)
        .then((response) {
          // Se o código for válido, redireciona para a página de redefinição de senha

          //Guarda token no sharedPreferences
          localStorageService.setValue('token', response.token);
          Navigator.pushNamed(
            context,
            '/change-password',
            arguments: response.token,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Código verificado com sucesso!')),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao verificar código: $error')),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Código de Recuperação'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titulo da página
            const Text(
              'Código de Recuperação',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            CustomTextField(
              controller: codigoController,

              hintText: 'Digite o código enviado para seu email',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.bottomRight,
              child: CustomElevatedButton(
                label: 'Verificar',
                onPressed: () {
                  verificarCodigo(codigoController.text);
                },
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
