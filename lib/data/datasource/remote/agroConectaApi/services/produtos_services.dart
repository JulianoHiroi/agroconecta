import 'package:agroconecta/data/datasource/remote/agroConectaApi/agroconecta_services.dart';
import 'package:agroconecta/data/models/produto.dart';
import 'package:agroconecta/data/models/tipo_produto.dart';

class ProdutosServices extends AgroConectaApiService {
  Future getAllProdutos() async {
    try {
      final response = await dio.get('/api/products/user');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => Produto.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Erro ao obter produtos: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao obter produtos: $e');
      throw Exception('Erro ao obter produtos: $e');
    }
  }

  Future getAllTiposProdutos() async {
    try {
      final response = await dio.get('/api/products/types');
      if (response.statusCode == 200) {
        return GetAllTiposProdutosResponse.fromJson(
          response.data,
        ).tiposProdutos;
      } else {
        throw Exception(
          'Erro ao obter tipos de produtos: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao obter tipos de produtos: $e');
      throw Exception('Erro ao obter tipos de produtos: $e');
    }
  }

  Future createProduto({
    required String? tipoProdutoId,
    required String description,
    required double price,
  }) async {
    try {
      final response = await dio.post(
        '/api/products/',
        data: {
          'idTypeProduct': tipoProdutoId,
          'description': description,
          'price': price,
        },
      );
      if (response.statusCode == 201) {
        return Produto.fromJson(response.data);
      } else {
        throw Exception('Erro ao criar produto: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao criar produto: $e');
      throw Exception('Erro ao criar produto: $e');
    }
  }

  Future deleteProduto(String id) async {
    try {
      final response = await dio.delete('/api/products/$id');
      if (response.statusCode == 204) {
        return true; // Produto deletado com sucesso
      } else {
        throw Exception('Erro ao deletar produto: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao deletar produto: $e');
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  Future connectProdutoToEstabelecimento({
    required String idEstabelecimento,
    required String idProduto,
    required double quantidade,
  }) async {
    try {
      print(
        'Conectando produto $idProduto ao estabelecimento $idEstabelecimento com quantidade $quantidade',
      );
      final response = await dio.patch(
        '/api/products/connect/$idEstabelecimento/$idProduto',
        data: {'quantity': quantidade},
      );

      if (response.statusCode == 201) {
        return true; // Produto conectado com sucesso
      }
    } catch (e) {
      throw Exception('Erro ao conectar produto ao estabelecimento: $e');
    }
  }

  Future disconnectProdutoFromEstabelecimento({
    required String idEstabelecimento,
    required String idProduto,
  }) async {
    try {
      final response = await dio.delete(
        '/api/products/disconnect/$idEstabelecimento/$idProduto',
      );
      if (response.statusCode == 204) {
        return true; // Produto desconectado com sucesso
      } else {
        throw Exception(
          'Erro ao desconectar produto do estabelecimento: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao desconectar produto do estabelecimento: $e');
      throw Exception('Erro ao desconectar produto do estabelecimento: $e');
    }
  }
}

class GetAllTiposProdutosResponse {
  final List<TipoProduto> tiposProdutos;

  GetAllTiposProdutosResponse({required this.tiposProdutos});

  factory GetAllTiposProdutosResponse.fromJson(List<dynamic> json) {
    return GetAllTiposProdutosResponse(
      tiposProdutos: json
          .map((item) => TipoProduto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
