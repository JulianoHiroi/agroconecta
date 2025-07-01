import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/produtos_services.dart';
import 'package:agroconecta/data/models/produto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final produtosApi = ProdutosServices();
  List<Produto> produtos = [];
  bool loading = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    buscarProdutos();
  }

  Future<void> buscarProdutos() async {
    try {
      var response = await produtosApi.getAllProdutos();
      setState(() {
        produtos = response;
        erro = produtos.isEmpty ? 'Nenhum produto encontrado.' : null;
        loading = false;
      });
    } catch (e) {
      setState(() {
        erro = 'Erro ao carregar produtos';
        loading = false;
      });
    }
  }

  String formatarPreco(double preco) {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return '${formatador.format(preco)} / Kg';
  }

  Future<void> _deletarProduto(String id) async {
    try {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir este produto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmado == true) {
        await produtosApi.deleteProduto(id);
        buscarProdutos(); // Recarrega a lista após deletar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto excluído com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir produto: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : erro != null
          ? Center(child: Text(erro!))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  color: const Color(0xFFFFFBFB),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      produto.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Preço: ${formatarPreco(produto.price)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                          onPressed: () => _deletarProduto(produto.id),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/edit-product/${produto.id}',
                      ).then((_) => buscarProdutos());
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/create-product',
          ).then((_) => buscarProdutos());
        },
        backgroundColor: Colors.grey.shade400,
        child: const Icon(Icons.add),
      ),
    );
  }
}
