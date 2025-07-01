import 'dart:io';

import 'package:agroconecta/data/datasource/remote/agroConectaApi/agroconecta_services.dart';
import 'package:agroconecta/data/models/estabelecimento.dart';
import 'package:dio/dio.dart';

class EstabelecimentosServices extends AgroConectaApiService {
  // Método corrigido
  Future<List<Estabelecimento>> getAllEstabelecimentos() async {
    try {
      final response = await dio.get('/api/establishments/');
      if (response.statusCode == 200) {
        var data = response.data;
        if (data is List) {
          return GetAllEstabelecimentosResponse.fromJson(data).estabelecimentos;
        } else {
          throw Exception('Formato inválido de dados da API');
        }
      } else {
        throw Exception(
          'Erro ao obter estabelecimentos: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao obter estabelecimentos: $e');
      throw Exception('Erro ao obter estabelecimentos: $e');
    }
  }

  Future<CreateEstabelecimentoResponse> createEstabelecimento(
    String name,
    String logradouro,
    int numero,
    String cep,
    String phone,
  ) async {
    try {
      final estabelecimento = Estabelecimento(
        id: '',
        name: name,
        logradouro: logradouro,
        latitude: null,
        longitude: null,
        imageProfileUrl: '',
        number: numero.toString(),
        CEP: cep,
        phone: phone,
        description: null,
        images: [],
      );

      final response = await dio.post(
        '/api/establishments/',
        data: estabelecimento.toJson(),
      );
      if (response.statusCode == 201) {
        Estabelecimento estabelecimento = Estabelecimento.fromJson(
          response.data,
        );
        return CreateEstabelecimentoResponse(
          sucesso: true,
          estabelecimento: estabelecimento,
        );
      } else {
        throw Exception(
          'Erro ao criar estabelecimento: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao criar estabelecimento: $e');
      throw Exception('Erro ao criar estabelecimento: $e');
    }
  }

  Future<Estabelecimento> getEstabelecimentoById(String id) async {
    try {
      final response = await dio.get('/api/establishments/$id');
      if (response.statusCode == 200) {
        return Estabelecimento.fromJson(response.data);
      } else {
        throw Exception(
          'Erro ao obter estabelecimento: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao obter estabelecimento: $e');
      throw Exception('Erro ao obter estabelecimento: $e');
    }
  }

  Future<void> atualizarFotoEstabelecimento(String id, File image) async {
    try {
      final formData = FormData.fromMap({
        'imageProfile': await MultipartFile.fromFile(image.path),
      });
      final response = await dio.patch(
        '/api/establishments/imageProfile/$id',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Erro ao atualizar foto do estabelecimento: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao atualizar foto do estabelecimento: $e');
      throw Exception('Erro ao atualizar foto do estabelecimento: $e');
    }
  }

  Future<void> adicionaFotoEstabelecimento(String id, File image) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });
      print("saidjasi");
      final response = await dio.patch(
        '/api/establishments/image/$id',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Erro ao adicionar foto do estabelecimento: ${response.statusMessage}',
        );
      } else {
        print('Foto do estabelecimento adicionada com sucesso!');
      }
    } catch (e) {
      print('Erro ao adicionar foto do estabelecimento: $e');
      throw Exception('Erro ao adicionar foto do estabelecimento: $e');
    }
  }

  Future<void> deleteEstabelecimento(String id) async {
    try {
      final response = await dio.delete('/api/establishments/$id');
      if (response.statusCode != 204) {
        throw Exception(
          'Erro ao excluir estabelecimento: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao excluir estabelecimento: $e');
      throw Exception('Erro ao excluir estabelecimento: $e');
    }
  }
}

class GetAllEstabelecimentosResponse {
  final List<Estabelecimento> estabelecimentos;
  GetAllEstabelecimentosResponse({required this.estabelecimentos});

  factory GetAllEstabelecimentosResponse.fromJson(List<dynamic> json) {
    return GetAllEstabelecimentosResponse(
      estabelecimentos: json
          .map((item) => Estabelecimento.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CreateEstabelecimentoResponse {
  final bool sucesso;
  final Estabelecimento estabelecimento;

  CreateEstabelecimentoResponse({
    required this.sucesso,
    required this.estabelecimento,
  });
}
