import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/auth_services.dart';
import 'package:agroconecta/view/utils/exception-utils.dart';
import 'package:agroconecta/view/widgets/components/custom_data_picker.dart';
import 'package:agroconecta/view/widgets/components/custom_dropdown_button.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:agroconecta/view/widgets/components/custom_text_field.dart';
import 'package:agroconecta/view/widgets/logo/logo.widget.dart';
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
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.grey,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),

          child: Column(
            children: [
              const LogoWidget(),
              const SizedBox(height: 30),
              CustomTextField(
                controller: nameController,
                label: 'Nome',
                hintText: 'Digite seu nome completo',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                hintText: 'Digite seu email',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                label: 'Senha',
                obscureText: true,
                hintText: 'Digite sua senha',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: confirmPasswordController,
                label: 'Confirmar Senha',
                obscureText: true,
                hintText: 'Confirme sua senha',
              ),
              const SizedBox(height: 16),
              CustomDropdownButton(
                value: selectedGender,
                label: 'Gênero',
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Masculino')),
                  DropdownMenuItem(value: 'female', child: Text('Feminino')),
                  DropdownMenuItem(value: 'other', child: Text('Outro')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomDatePicker(
                label: 'Data de nascimento',
                selectedDate: selectedDate,
                onTap: _selectDate,
              ),
              const SizedBox(height: 24),
              CustomElevatedButton(
                label: 'Cadastro',
                onPressed: () {
                  if (passwordController.text !=
                      confirmPasswordController.text) {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
