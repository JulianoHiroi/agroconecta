import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/produtos_services.dart';
import 'package:agroconecta/data/models/tipo_produto.dart';
import 'package:agroconecta/view/widgets/components/custom_droptdown_search.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:agroconecta/view/widgets/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();

  final ProdutosServices produtosApi = ProdutosServices();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? selectedId; // Correção: valor inicial null

  List<TipoProduto> tiposProdutos = [];
  bool loading = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    buscarTiposProdutos();
  }

  Future<void> buscarTiposProdutos() async {
    try {
      var response = await produtosApi.getAllTiposProdutos();
      setState(() {
        tiposProdutos = response;
        erro = tiposProdutos.isEmpty
            ? 'Nenhum tipo de produto encontrado.'
            : null;
        loading = false;
      });
    } catch (e) {
      setState(() {
        erro = 'Erro ao carregar tipos de produtos';
        loading = false;
      });
    }
  }

  Future<void> criarProduto() async {
    if (_formKey.currentState?.validate() ?? false) {
      var response = await produtosApi.createProduto(
        tipoProdutoId: selectedId,
        description: descriptionController.text,
        price:
            double.tryParse(
              priceController.text.replaceAll('R\$ ', '').replaceAll(',', '.'),
            ) ??
            0.0,
      );

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto criado com sucesso!')),
        );
        Navigator.pop(context); // Volta para a tela anterior
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao criar produto.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Produto'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropdownSearch(
                      value: selectedId,
                      label: 'Tipo do Produto',
                      items: tiposProdutos.map((tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo.id,
                          child: Text(tipo.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: descriptionController,
                      label: 'Descrição do Produto',
                      hintText: 'Digite a descrição do produto',
                    ),
                    const SizedBox(height: 16),
                    //Faça uma input de preço com máscara sem usar o CustomTextField faça um formato de moeda R$ que só aceita números e vírgula
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Preço',
                        hintText: 'Digite o preço do produto',
                        prefixText: 'R\$ ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomElevatedButton(
                      label: "Criar produto",
                      onPressed: () => criarProduto(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
