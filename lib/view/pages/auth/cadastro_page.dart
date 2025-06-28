import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/auth_services.dart';
import 'package:agroconecta/view/utils/exception-utils.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? selectedGender;
  DateTime? selectedDate;

  final authApi =
      AuthServices(); // Supondo que AuthServices esteja implementado

  void fazerCadastro(String nome, String email, String senha) {
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    if (senha != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem')));
      return;
    }

    if (selectedGender == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione gênero e data de nascimento')),
      );
      return;
    }

    handleAsync(
      context: context,
      operation: () async {
        final response = await authApi.register(
          nome,
          email,
          senha,
          selectedDate!,
          selectedGender!,
        );
        if (response.token.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cadastro realizado com sucesso!')),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao cadastrar usuário')),
          );
        }
      },
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedGender,
              hint: const Text('Gênero'),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Masculino')),
                DropdownMenuItem(value: 'female', child: Text('Feminino')),
                DropdownMenuItem(value: 'other', child: Text('Outro')),
              ],
              onChanged: (value) => setState(() {
                selectedGender = value;
              }),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? 'Data de nascimento: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Nenhuma data selecionada',
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: const Text('Selecionar Data'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('As senhas não coincidem')),
                  );
                  return;
                }

                if (selectedGender == null || selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos')),
                  );
                  return;
                }

                fazerCadastro(
                  nameController.text,
                  emailController.text,
                  passwordController.text,
                );
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
