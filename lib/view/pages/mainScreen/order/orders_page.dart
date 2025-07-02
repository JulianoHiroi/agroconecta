import 'package:agroconecta/data/datasource/local/local_storage_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/order_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/produtos_services.dart';
import 'package:agroconecta/data/models/order.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderServices orderServices = OrderServices();
  final ProdutosServices productServices = ProdutosServices();
  final List<Order> orders = [];
  final List<Order> ordersReceived = [];
  final LocalStorageService localStorageService = LocalStorageService();
  bool _isLoading = true;

  _makePayment(Order order) async {
    try {
      await orderServices.confirmPayment(order.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pagamento do pedido ${order.id} confirmado.')),
      );
      _carregarPedidos();
    } catch (e) {
      print('Erro ao processar pagamento: $e');
    }
  }

  void _avaliarProduto(Order order) {
    int _avaliacaoSelecionada = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Text(
                            order.productName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${order.establishmentName}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Como você avalia este produto?',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          iconSize: 32,
                          icon: Icon(
                            index < _avaliacaoSelecionada
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              _avaliacaoSelecionada = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    CustomElevatedButton(
                      onPressed: () {
                        if (_avaliacaoSelecionada == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, selecione uma avaliação.',
                              ),
                            ),
                          );
                          return;
                        }
                        Navigator.pop(context);
                        productServices.makeAvaliation(
                          productId: order.productId,
                          rating: _avaliacaoSelecionada,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Avaliação de ${order.productName} enviada com sucesso!',
                            ),
                          ),
                        );
                        // Aqui você pode adicionar a lógica para enviar a avaliação
                        // por exemplo, chamar um serviço de avaliação
                      },
                      color: Colors.green,
                      label: 'Enviar Avaliação',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _cancelOrder(Order order) async {
    try {
      await orderServices.cancelOrder(order.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido ${order.id} cancelado com sucesso.')),
      );
      _carregarPedidos(); // Recarrega a lista de pedidos após o cancelamento
    } catch (e) {
      print('Erro ao cancelar pedido: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  void _showOrderDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'Pedido',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Data do pedido: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pedido ${order.id} pago.')),
                          );
                          _cancelOrder(order);
                        },
                        color: Colors.red,

                        label: 'Cancelar',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pedido ${order.id} confirmado.'),
                            ),
                          );
                          _makePayment(order);
                        },
                        color: Colors.green,
                        label: 'Pagar',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _carregarPedidos() async {
    try {
      final List<Order> pedidos = await orderServices.getAllOrders();
      String? userId = await localStorageService.getValue('userId');
      if (userId == null) {
        print('Usuário não autenticado. Não é possível carregar pedidos.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      pedidos.forEach((pedido) {
        print(
          'Pedido: ${pedido.id}, Produto: ${pedido.productName}, Quantidade: ${pedido.quantity}, Valor: ${pedido.amountPayment}, Estabelecimento: ${pedido.establishmentName}, Status: ${pedido.statusName}, UserId: ${pedido.userId}, UserProductId: ${pedido.userProductId}',
        );
      });
      orders.clear();
      ordersReceived.clear();

      setState(() {
        // faça um filtro de pedidos que o usuário autenticado tem id igual ao userId
        orders.addAll(pedidos.where((pedido) => pedido.userId == userId));
        ordersReceived.addAll(
          pedidos.where((pedido) => pedido.userProductId == userId),
        );
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar pedidos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : (orders.isEmpty && ordersReceived.isEmpty)
            ? const Center(child: Text('Nenhum pedido encontrado.'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (orders.isNotEmpty) ...[
                      const Text(
                        'Pedidos Feitos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...orders
                          .map((order) => _buildOrderCard(order, isBuyer: true))
                          .toList(),
                      const SizedBox(height: 24),
                    ],
                    if (ordersReceived.isNotEmpty) ...[
                      const Text(
                        'Pedidos Recebidos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...ordersReceived
                          .map(
                            (order) => _buildOrderCard(order, isBuyer: false),
                          )
                          .toList(),
                    ],
                  ],
                ),
              ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildOrderCard(Order order, {required bool isBuyer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantidade: ${order.quantity}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  'Valor: R\$ ${order.amountPayment.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estabelecimento: ${order.establishmentName}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  'Status: ${order.statusName}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          Row(
            children: [
              if (order.statusName == 'Pendente')
                IconButton(
                  icon: const Icon(Icons.payment),
                  iconSize: 32,
                  onPressed: () {
                    _showOrderDialog(order);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pagamento do pedido ${order.id} iniciado.',
                        ),
                      ),
                    );
                  },
                ),
              if (order.statusName == 'Confirmado')
                IconButton(
                  icon: const Icon(Icons.star_rate_rounded),
                  iconSize: 32,
                  color: Colors.amber,
                  onPressed: () {
                    // Lógica para abrir avaliação do produto
                    _avaliarProduto(order);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
