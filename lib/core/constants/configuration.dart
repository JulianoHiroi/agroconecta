// import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configuration {
  static String get agroConectaServerUrl {
    // Obtém a URL do servidor AgroConecta do arquivo .env
    return "http://10.0.2.2:4000";
  }

  static int get timeout {
    // Obtém o tempo limite de conexão do arquivo .env, com valor padrão de 5000 ms
    return 5000;
  }

  static String get routeImages {
    return "$agroConectaServerUrl/api/assets/";
  }
}
