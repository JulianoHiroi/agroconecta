import 'package:agroconecta/data/datasource/remote/agroConectaApi/agroconecta_services.dart';
import 'package:dio/dio.dart';

class AuthServices extends AgroConectaApiService {
  Future<Response> login(String email, String password) async {
    final response = await dio.post(
      '/api/users/signin',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to login: ${response.data}');
    }
    if (response.data['token'] == null) {
      throw Exception('Token not found in response');
    }

    dio.options.headers['Authorization'] = 'Bearer ${response.data['token']}';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
    return response;
  }

  Future<Response> register(String name, String email, String password) async {
    final response = await dio.post(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
    return response;
  }
}

class LoginResponse {
  final String token;
  final String userId;

  LoginResponse({required this.token, required this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token'], user: json['user']['id']);
  }
}
