import 'package:agroconecta/core/exceptions/exceptions.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/agroconecta_services.dart';
import 'package:agroconecta/data/models/user.dart';
import 'package:dio/dio.dart';

class AuthServices extends AgroConectaApiService {
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/users/signin',
        data: {'email': email, 'password': password},
      );
      handleError(response);
      dio.options.headers['Authorization'] = 'Bearer ${response.data['token']}';
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Access-Control-Allow-Origin'] = '*';

      // Cria o objeto LoginResponse a partir da resposta
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Tratar erros específicos do Dio
      if (e.response != null) {
        handleError(e.response!);
      } else {
        throw UnexpectedException('Erro de conexão: ${e.message}');
      }
    } catch (e) {
      // Tratar outros erros inesperados
      throw UnexpectedException('Erro inesperado: $e');
    }
    throw UnexpectedException('Erro desconhecido ao fazer login.');
  }

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
    DateTime birthdate,
    String gender,
  ) async {
    try {
      final response = await dio.post(
        '/api/users/signup',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'date_of_birth': birthdate.toIso8601String(),
          'gender': gender,
        },
      );
      handleError(response);
      dio.options.headers['Authorization'] = 'Bearer ${response.data['token']}';
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Access-Control-Allow-Origin'] = '*';

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Tratar erros específicos do Dio
      if (e.response != null) {
        handleError(e.response!);
      } else {
        throw UnexpectedException('Erro de conexão: ${e.message}');
      }
    } catch (e) {
      // Tratar outros erros inesperados
      throw UnexpectedException('Erro inesperado: $e');
    }
    throw UnexpectedException('Erro desconhecido ao fazer login.');
  }

  Future<RecuperarSenhaResponse> recuperarSenha(String email) async {
    try {
      final response = await dio.post(
        '/api/users/recoverypassword',
        data: {'email': email},
      );
      handleError(response);
      return RecuperarSenhaResponse(success: true);
    } on DioException catch (e) {
      // Tratar erros específicos do Dio
      if (e.response != null) {
        handleError(e.response!);
      } else {
        throw UnexpectedException('Erro de conexão: ${e.message}');
      }
    } catch (e) {
      // Tratar outros erros inesperados
      throw UnexpectedException('Erro inesperado: $e');
    }
    throw UnexpectedException('Erro desconhecido ao recuperar senha.');
  }

  Future<ValidarCodigoResponse> verificarCodigo(
    String codigo,
    String email,
  ) async {
    try {
      final response = await dio.post(
        '/api/users/validaterecoverycode',
        data: {'code': codigo, 'email': email},
      );
      handleError(response);

      ValidarCodigoResponse validarCodigoResponse =
          ValidarCodigoResponse.fromJson(response.data);
      return validarCodigoResponse;
    } on DioException catch (e) {
      // Tratar erros específicos do Dio
      if (e.response != null) {
        handleError(e.response!);
      } else {
        throw UnexpectedException('Erro de conexão: ${e.message}');
      }
    } catch (e) {
      // Tratar outros erros inesperados
      throw UnexpectedException('Erro inesperado: $e');
    }
    throw UnexpectedException('Erro desconhecido ao verificar código.');
  }

  Future<AlterarSenhaResponse> alterarSenha(
    String token,
    String novaSenha,
  ) async {
    try {
      final response = await dio.patch(
        '/api/users/changepassword',
        data: {'token': token, 'password': novaSenha},
      );
      handleError(response);
      return AlterarSenhaResponse(success: true);
    } on DioException catch (e) {
      // Tratar erros específicos do Dio
      if (e.response != null) {
        handleError(e.response!);
      } else {
        throw UnexpectedException('Erro de conexão: ${e.message}');
      }
    } catch (e) {
      // Tratar outros erros inesperados
      throw UnexpectedException('Erro inesperado: $e');
    }
    return AlterarSenhaResponse(success: false);
  }

  Future<void> logout() async {
    try {
      dio.options.headers.remove('Authorization');
      dio.options.headers.remove('Content-Type');
      dio.options.headers.remove('Accept');
      dio.options.headers.remove('Access-Control-Allow-Origin');
    } catch (e) {
      throw UnexpectedException('Erro ao fazer logout: $e');
    }
  }

  void CarregarToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
  }
}

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

// faça a classe RegisterResponse sabendo quye ele é esses campos:
class RegisterResponse {
  final String token;
  final User user;

  RegisterResponse({required this.token, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

class RecuperarSenhaResponse {
  final bool success;

  RecuperarSenhaResponse({required this.success});
}

class ValidarCodigoResponse {
  final String token;
  ValidarCodigoResponse({required this.token});

  factory ValidarCodigoResponse.fromJson(Map<String, dynamic> json) {
    return ValidarCodigoResponse(token: json['token']);
  }
}

class AlterarSenhaResponse {
  final bool success;

  AlterarSenhaResponse({required this.success});
}
