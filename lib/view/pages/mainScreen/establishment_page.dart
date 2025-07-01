import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/estabelecimentos_services.dart';
import 'package:agroconecta/data/models/estabelecimento.dart';
import 'package:agroconecta/data/models/produto.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:agroconecta/view/widgets/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewEstabelecimentoPage extends StatefulWidget {
  final String idEstabelecimento;

  const ViewEstabelecimentoPage({Key? key, required this.idEstabelecimento})
    : super(key: key);

  @override
  _ViewEstabelecimentoPageState createState() =>
      _ViewEstabelecimentoPageState();
}

class _ViewEstabelecimentoPageState extends State<ViewEstabelecimentoPage> {
  Estabelecimento? estabelecimento;
  final EstabelecimentosServices estabelecimentosApi =
      EstabelecimentosServices();
  String endereco = "Carregando...";

  @override
  void initState() {
    super.initState();
    carregarEstabelecimento();
  }

  Future<void> carregarEstabelecimento() async {
    try {
      estabelecimento = await estabelecimentosApi.getEstabelecimentoById(
        widget.idEstabelecimento,
      );
      if (estabelecimento == null) {
        throw Exception("Estabelecimento não encontrado");
      }
      endereco =
          "${estabelecimento!.logradouro}, ${estabelecimento!.number}, "
          "${estabelecimento!.CEP}";
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar estabelecimento: \$e')),
      );
      Navigator.of(context).pop();
    }
  }

  void _mostrarModalCompra(Produto produto) {
    double _valortotal = 0.0;
    final _quantidadeController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    void calcularValorTotal(String quantidade, double precoPorKg) {
      final q = double.tryParse(quantidade);
      if (q != null && q > 0) {
        setState(() {
          _valortotal = q * precoPorKg;
        });
      } else {
        setState(() {
          _valortotal = 0.0;
        });
      }
    }

    String formatarPreco(double preco) {
      final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
      return formatador.format(preco);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Comprar ${produto.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _quantidadeController,
                        keyboardType: TextInputType.number,
                        label: 'Quantidade (Kg)',
                        hintText: 'Informe a quantidade em Kg',
                        onChanged: (value) {
                          setModalState(() {
                            calcularValorTotal(value, produto.price);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a quantidade';
                          }
                          final q = double.tryParse(value);

                          if (q == null ||
                              q <= 0 ||
                              q > (produto.quantity ?? 0)) {
                            return 'Quantidade inválida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Faça um campo para exibir o preco total de acordo com a quantidade e o price do produto que está em reais, a quantidade deve ser em Kg e o preco está por kilo do produto
                      Container(
                        padding: const EdgeInsets.all(0),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preço por Kg: ${formatarPreco(produto.price)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Preço total: ${formatarPreco(_valortotal)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              label: 'Cancelar',
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Pedido de ${_quantidadeController.text} Kg de ${produto.name} realizado!',
                                      ),
                                    ),
                                  );
                                  // Aqui você poderia chamar um serviço de pedido se quiser
                                }
                              },
                              label: 'Fazer Pedido',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String formatarPreco(double preco) {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatador.format(preco);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estabelecimento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: estabelecimento?.imageProfileUrl != null
                          ? NetworkImage(estabelecimento!.imageProfileUrl!)
                          : null,
                      child: estabelecimento?.imageProfileUrl == null
                          ? const Icon(
                              Icons.store,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      estabelecimento?.name ?? "Carregando...",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(
                      text: "Endereço: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: endereco,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(
                      text: "Telefone: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: estabelecimento?.phone ?? "Carregando...",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Fotos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              (estabelecimento?.images == null ||
                      estabelecimento!.images!.isEmpty)
                  ? const Text("Nenhuma imagem disponível")
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...?estabelecimento?.images?.map((image) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              image.url,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ],
                    ),

              const SizedBox(height: 24),
              const Text(
                "Produtos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (estabelecimento?.produtos != null)
                ...estabelecimento!.produtos!.map((produto) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(produto.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preço: ${formatarPreco(produto.price)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Quantidade disponível: ${produto.quantity} Kg',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: CustomElevatedButton(
                        onPressed: () {
                          _mostrarModalCompra(produto);
                        },
                        label: 'Comprar',
                        width: 100,
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
