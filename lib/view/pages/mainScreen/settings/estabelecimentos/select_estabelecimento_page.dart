import 'dart:io';

import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/estabelecimentos_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/produtos_services.dart';
import 'package:agroconecta/data/models/estabelecimento.dart';
import 'package:agroconecta/data/models/produto.dart';
import 'package:agroconecta/external/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditEstabelecimentoPage extends StatefulWidget {
  final String idEstabelecimento;

  const EditEstabelecimentoPage({Key? key, required this.idEstabelecimento})
    : super(key: key);

  @override
  _EditEstabelecimentoPageState createState() =>
      _EditEstabelecimentoPageState();
}

class _EditEstabelecimentoPageState extends State<EditEstabelecimentoPage> {
  Estabelecimento? estabelecimento;
  final EstabelecimentosServices estabelecementosApi =
      EstabelecimentosServices();

  final ProdutosServices produtosApi = ProdutosServices();
  final ImageService _imageService = ImageService();
  String endereco = "Carregando...";

  // Carrega o estabelecimento ao iniciar a página
  @override
  void initState() {
    super.initState();
    carregaEstabelecimento();
  }

  Future<void> carregaEstabelecimento() async {
    try {
      estabelecimento = await estabelecementosApi.getEstabelecimentoById(
        widget.idEstabelecimento,
      );
      print('Estabelecimento carregado: $estabelecimento');
      if (estabelecimento == null) {
        throw Exception("Estabelecimento não encontrado");
      }
      endereco =
          "${estabelecimento!.logradouro}, ${estabelecimento!.number}, ${estabelecimento!.CEP}";
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar estabelecimento: $e')),
      );
      // Volta para a página anterior em caso de erro
      Navigator.of(context).pop();
    }
  }

  // Método para adicionar uma foto (exemplo simples)
  void _adicionarFoto() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da Galeria'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? image = await _imageService
                      .pickImageFromGallery();
                  if (image != null) {
                    estabelecementosApi
                        .adicionaFotoEstabelecimento(
                          widget.idEstabelecimento,
                          image,
                        )
                        .then((value) => carregaEstabelecimento())
                        .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao adicionar foto: $error'),
                            ),
                          );
                        });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar Foto com a Câmera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? image = await _imageService.getImageFromCamera();
                  if (image != null) {
                    estabelecementosApi
                        .adicionaFotoEstabelecimento(
                          widget.idEstabelecimento,
                          image,
                        )
                        .then(
                          (value) => carregaEstabelecimento(
                            // Recarrega o estabelecimento após adicionar a foto
                          ),
                        )
                        .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao adicionar foto: $error'),
                            ),
                          );
                        });
                  }
                },
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      carregaEstabelecimento();
    });
  }

  String formatarPreco(double preco) {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return '${formatador.format(preco)} / Kg';
  }

  Future<void> _adicionarProduto() async {
    // Carrega os produtos disponíveis
    List<Produto> produtosDisponiveis = await produtosApi.getAllProdutos();

    if (produtosDisponiveis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum produto disponível')),
      );
      return;
    }

    // Controladores para os campos do formulário
    final _formKey = GlobalKey<FormState>();
    final _quantidadeController = TextEditingController();
    Produto? _produtoSelecionado;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Adicionar Produto',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Dropdown para selecionar o produto
                  DropdownButtonFormField<Produto>(
                    decoration: const InputDecoration(
                      labelText: 'Produto',
                      border: OutlineInputBorder(),
                    ),
                    items: produtosDisponiveis.map((Produto produto) {
                      return DropdownMenuItem<Produto>(
                        value: produto,
                        child: Text(produto.name),
                      );
                    }).toList(),
                    onChanged: (Produto? novoProduto) {
                      setState(() {
                        _produtoSelecionado = novoProduto;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione um produto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de quantidade
                  TextFormField(
                    controller: _quantidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a quantidade';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Quantidade inválida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Botão de adicionar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Aqui você implementaria a lógica para adicionar o produto
                            // ao estabelecimento usando a API
                            await produtosApi.connectProdutoToEstabelecimento(
                              idEstabelecimento: widget.idEstabelecimento,
                              idProduto: _produtoSelecionado!.id,
                              quantidade: double.parse(
                                _quantidadeController.text,
                              ),
                            );

                            // Recarrega os dados do estabelecimento
                            await carregaEstabelecimento();

                            // Fecha a modal
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Produto adicionado com sucesso!',
                                ),
                              ),
                            );
                          } catch (e) {
                            await carregaEstabelecimento();

                            // Fecha a modal
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erro ao adicionar produto: Item já adicionado ou erro na conexão',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Adicionar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Método para editar produto (exemplo)
  Future<void> _deleteProduto(int index) async {
    if (estabelecimento?.produtos == null ||
        index < 0 ||
        index >= estabelecimento!.produtos!.length) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Produto não encontrado')));
      return;
    }
    var response = await produtosApi.disconnectProdutoFromEstabelecimento(
      idEstabelecimento: widget.idEstabelecimento,
      idProduto: estabelecimento!.produtos![index].id,
    );

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto desconectado com sucesso!')),
      );
      // Recarrega o estabelecimento após deletar o produto
      carregaEstabelecimento();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao desconectar produto')),
      );
    }
  }

  void _alterarFotoEstabelecimento() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da Galeria'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? image = await _imageService
                      .pickImageFromGallery();
                  if (image != null) {
                    estabelecementosApi
                        .atualizarFotoEstabelecimento(
                          widget.idEstabelecimento,
                          image,
                        )
                        .then(
                          (value) => carregaEstabelecimento(
                            // Recarrega o estabelecimento após adicionar a foto
                          ),
                        )
                        .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao adicionar foto: $error'),
                            ),
                          );
                        });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar Foto com a Câmera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? image = await _imageService.getImageFromCamera();
                  if (image != null) {
                    estabelecementosApi
                        .atualizarFotoEstabelecimento(
                          widget.idEstabelecimento,
                          image,
                        )
                        .then(
                          (value) => carregaEstabelecimento(
                            // Recarrega o estabelecimento após adicionar a foto
                          ),
                        )
                        .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao adicionar foto: $error'),
                            ),
                          );
                        });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    setState(() {
      carregaEstabelecimento();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Estabelecimento')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          estabelecementosApi
              .deleteEstabelecimento(widget.idEstabelecimento)
              .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Estabelecimento excluído com sucesso!'),
                  ),
                );
                Navigator.pop(context); // Volta para a página anterior
              })
              .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao excluir estabelecimento: $error'),
                  ),
                );
              });
        },
        child: const Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Faça um bola com o foto do estabelecimento
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              estabelecimento?.imageProfileUrl != null
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              _alterarFotoEstabelecimento();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // faça um botão para editar a foto
                    const SizedBox(height: 16),
                    // Nome do estabelecimento
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

              // Endereço
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
              // telefone
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
              // Fotos
              const Text(
                "Fotos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Lista de fotos (placeholder) em formato de cards com um botão de adicionar no final
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Mostra as imagens existentes
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

                  // Botão para adicionar nova imagem
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: _adicionarFoto,
                      child: const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(child: Icon(Icons.add_a_photo, size: 40)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Produtos
              const Text(
                "Produtos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (estabelecimento?.produtos != null)
                ...estabelecimento!.produtos!.asMap().entries.map((entry) {
                  int index = entry.key;
                  Produto produto = entry.value;

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
                            'Quantidade: ${produto.quantity}Kg',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteProduto(index),
                      ),
                    ),
                  );
                }),

              // Botão adicionar produto grande
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _adicionarProduto,
                  icon: const Icon(Icons.add),
                  label: const Text("Adicionar Produto"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
