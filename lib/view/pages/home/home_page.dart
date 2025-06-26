import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Bem-vindo à página inicial!')),
      // Faça um botão para ir para pagina de configurações
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        tooltip: 'Configurações',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
