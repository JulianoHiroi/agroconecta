import 'package:agroconecta/data/datasource/remote/agroConectaApi/agroconecta_services.dart';
import 'package:agroconecta/data/models/order.dart';

class OrderServices extends AgroConectaApiService {
  Future<List<Order>> getAllOrders() async {
    try {
      final response = await dio.get('/api/orders/user');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return GetALlOrdersResponse.fromJson(data).orders;
      } else if (response.statusCode == 404) {
        throw Exception('Pedidos não encontrados (404).');
      } else {
        throw Exception('Erro ao obter pedidos: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao obter pedidos: $e');
      throw Exception('Erro ao obter pedidos: $e');
    }
  }

  Future createOrder({
    required String productId,
    required String establishmentId,
    required double quantity,
  }) async {
    try {
      if (productId.isEmpty || establishmentId.isEmpty || quantity <= 0) {
        throw Exception('Dados inválidos para criar pedido.');
      }
      final response = await dio.post(
        '/api/orders/',
        data: {
          'productId': productId,
          'establishmentId': establishmentId,
          'quantity': quantity,
        },
      );
      if (response.statusCode == 201) {
        return response
            .data; // Assuming the response contains the created order
      } else {
        throw Exception('Erro ao criar pedido: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao criar pedido: $e');
      throw Exception('Erro ao criar pedido: $e');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final response = await dio.delete('/api/orders/$orderId');
      if (response.statusCode == 204) {
        return; // Pedido cancelado com sucesso
      } else {
        throw Exception('Erro ao cancelar pedido: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao cancelar pedido: $e');
      throw Exception('Erro ao cancelar pedido: $e');
    }
  }

  Future<void> confirmPayment(String orderId) async {
    try {
      final response = await dio.patch('/api/orders/payment/$orderId');
      if (response.statusCode == 204) {
        return; // Pagamento confirmado com sucesso
      } else {
        throw Exception(
          'Erro ao confirmar pagamento: ${response.statusMessage}',
        );
      }
    } catch (e) {
      print('Erro ao confirmar pagamento: $e');
      throw Exception('Erro ao confirmar pagamento: $e');
    }
  }
}

class GetALlOrdersResponse {
  final List<Order> orders;

  GetALlOrdersResponse({required this.orders});

  factory GetALlOrdersResponse.fromJson(List<dynamic> json) {
    return GetALlOrdersResponse(
      orders: json.map((item) => Order.fromJson(item)).toList(),
    );
  }
}
