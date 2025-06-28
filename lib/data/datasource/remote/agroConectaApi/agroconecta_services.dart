import 'package:agroconecta/core/constants/configuration.dart';
import 'package:agroconecta/core/exceptions/exceptions.dart';
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

  // Faça um handle de erro que para todas as requisições que não sejam 200
  void handleError(Response response) {
    if (response.statusCode == null) {
      throw UnexpectedException('Resposta nula do servidor.');
    }
    print('Status Code: ${response.statusCode}');
    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      switch (response.statusCode) {
        case 400:
          throw BadRequestException();
        case 401:
          throw UnauthorizedException();
        case 403:
          throw ForbiddenException();
        case 404:
          throw NotFoundException();
        case 500:
          throw ServerErrorException();
        default:
          print('Erro desconhecido: ${response.statusCode}');
          throw Exception(
            'Erro desconhecido: ${response.statusCode} - ${response.data}',
          );
      }
    }
  }
}
