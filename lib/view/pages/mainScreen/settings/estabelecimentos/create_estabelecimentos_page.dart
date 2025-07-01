import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/estabelecimentos_services.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:agroconecta/view/widgets/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class CreateEstabelecimentoPage extends StatefulWidget {
  const CreateEstabelecimentoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateEstabelecimentoPageState createState() =>
      _CreateEstabelecimentoPageState();
}

class _CreateEstabelecimentoPageState extends State<CreateEstabelecimentoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController logradouroController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cepController = TextEditingController();

  final EstabelecimentosServices estabelecimentosApi =
      EstabelecimentosServices();
  Future<void> createEstabelecimento() async {
    final name = nameController.text.trim();
    final logradouro = logradouroController.text.trim();
    final numero = numeroController.text.trim();
    if (numero.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O número não pode ser vazio')),
      );
      return;
    }
    final int numeroInt = int.tryParse(numero) ?? 0;
    if (numeroInt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O número deve ser um valor positivo')),
      );
      return;
    }
    final phone = phoneController.text.trim();
    final cep = cepController.text.trim();
    if (name.isEmpty ||
        logradouro.isEmpty ||
        numero.isEmpty ||
        phone.isEmpty ||
        cep.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }
    try {
      final response = await estabelecimentosApi.createEstabelecimento(
        name,
        logradouro,
        numeroInt,
        cep,
        phone,
      );
      if (response.sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estabelecimento criado com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar estabelecimento')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    logradouroController.dispose();
    numeroController.dispose();
    phoneController.dispose();
    cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Estabelecimento'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              label: 'Nome',
              hintText: 'Digite o nome do estabelecimento',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: logradouroController,
              label: 'Logradouro',
              hintText: 'Digite o logradouro',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: numeroController,
              label: 'Número',
              hintText: 'Digite o número',
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            CustomTextField(
              controller: cepController,
              label: 'CEP',
              hintText: 'Digite o CEP',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: phoneController,
              label: 'Telefone',
              hintText: 'Digite o telefone',
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),
            CustomElevatedButton(
              label: 'Criar Estabelecimento',
              onPressed: () {
                createEstabelecimento();
              },
            ),
          ],
        ),
      ),
    );
  }
}
