import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(
  //   fileName:
  //       "C:\\Users\\Juliano Hiroi\\Matérias\\Projetos\\agroconecta-server\\.env",
  // );
  // Inicialização de serviços antes do app começar (ex: SQLite, SharedPreferences, Firebase, etc).
  // await DatabaseService().init();
  // await PermissionService().checkPermissions();

  runApp(const AppWidget());
}
