import 'package:agroconecta/app/routes.dart';
import 'package:agroconecta/data/datasource/local/repositories/user.reposiroty.dart';
import 'package:flutter/material.dart';
import 'package:agroconecta/data/datasource/local/local_storage_services.dart';
import 'package:agroconecta/data/models/user.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final LocalStorageService _localStorageService = LocalStorageService();
  final UserRepository _userRepository = UserRepository();

  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = await _localStorageService.getValue('userId');
      if (userId != null) {
        final user = await _userRepository.getUserById(userId);
        setState(() {
          _user = user;
          _isLoading = false;
        });
      } else {
        // Se não encontrar userId, vai para login
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      }
    } catch (e) {
      print('Erro ao carregar usuário: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _localStorageService.removeValue('token');
    await _localStorageService.removeValue('userId');
    await _userRepository.deleteUser(_user!.id);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Usuário'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(
              child: Text('Erro ao carregar informações do usuário.'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoTile('Nome', _user!.name),
                  _infoTile('Email', _user!.email),
                  _infoTile(
                    'Gênero',
                    _user!.gender == 'male' ? 'Masculino' : 'Feminino',
                  ),
                  _infoTile(
                    'Data de nascimento',
                    '${_user!.dateOfBirth.day.toString().padLeft(2, '0')}/'
                        '${_user!.dateOfBirth.month.toString().padLeft(2, '0')}/'
                        '${_user!.dateOfBirth.year}',
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _logout,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
