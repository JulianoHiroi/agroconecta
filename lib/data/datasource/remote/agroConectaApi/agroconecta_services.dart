import 'package:agroconecta/core/constants/configuration.dart';
import 'package:dio/dio.dart';

class AgroConectaApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Configuration.agroConectaServerUrl,
      connectTimeout: Duration(milliseconds: Configuration.timeout),
      receiveTimeout: Duration(milliseconds: Configuration.timeout),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  get dio {
    return _dio;
  }
}
