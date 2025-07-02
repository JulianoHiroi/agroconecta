import 'dart:io';

import 'package:agroconecta/data/datasource/remote/agroConectaApi/agroconecta_services.dart';
import 'package:agroconecta/data/models/estabelecimento.dart';
import 'package:dio/dio.dart';

class EstabelecimentosServices extends AgroConectaApiService {
  // Método corrigido
  Future<List<Estabelecimento>> getAllEstabelecimentos() async {
    try {
      print('Obtendo todos os estabelecimentos...');
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
      print(response.data);
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

  /**
   * 
{
"lat": -25.4442,
"lng": -49.2104,
"idTypeProduct": "5a1eb127-0ed4-4a35-ba37-6800d6339355" ,
"searchRadius": 6,
"name": "Mercado"
}
   */

  Future<SearchEstabelecimentoResponse> searchEstabelecimento({
    required double lat,
    required double lng,
    String name = '',
    String idTypeProduct = '',
    int searchRadius = 6,
  }) async {
    try {
      final response = await dio.post(
        '/api/establishments/search',
        data: {
          'lat': lat,
          'lng': lng,
          'name': name,
          'idTypeProduct': idTypeProduct,
          'searchRadius': searchRadius,
        },
      );
      if (response.statusCode == 200) {
        return SearchEstabelecimentoResponse.fromList(response.data);
        ;
      } else {
        throw Exception(
          'Erro ao buscar estabelecimento: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao buscar estabelecimento: $e');
      throw Exception('Erro ao buscar estabelecimento: $e');
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

class SearchEstabelecimentoResponse {
  final List<ObjetoSearchResponseEstabelecimento> estabelecimentos;

  SearchEstabelecimentoResponse({required this.estabelecimentos});

  factory SearchEstabelecimentoResponse.fromList(List<dynamic> list) {
    return SearchEstabelecimentoResponse(
      estabelecimentos: list.map((item) {
        return ObjetoSearchResponseEstabelecimento.fromJson(
          item as Map<String, dynamic>,
        );
      }).toList(),
    );
  }
}

class ObjetoSearchResponseEstabelecimento {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  ObjetoSearchResponseEstabelecimento({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory ObjetoSearchResponseEstabelecimento.fromJson(
    Map<String, dynamic> json,
  ) {
    return ObjetoSearchResponseEstabelecimento(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitue'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
