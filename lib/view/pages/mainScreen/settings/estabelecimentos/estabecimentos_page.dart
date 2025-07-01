import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/estabelecimentos_services.dart';
import 'package:agroconecta/data/models/estabelecimento.dart';
import 'package:agroconecta/view/widgets/components/custom_list_item.dart';
import 'package:flutter/material.dart';

class EstabecimentosPage extends StatefulWidget {
  const EstabecimentosPage({Key? key}) : super(key: key);

  @override
  _EstabecimentosPageState createState() => _EstabecimentosPageState();
}

class _EstabecimentosPageState extends State<EstabecimentosPage> {
  final EstabelecimentosServices estabelecimentosApi =
      EstabelecimentosServices();

  List<Estabelecimento> estabelecimentos = [];
  bool loading = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    buscarEstabelecimentos();
  }

  Future<void> buscarEstabelecimentos() async {
    try {
      var response = await estabelecimentosApi.getAllEstabelecimentos();
      setState(() {
        estabelecimentos = response;
        if (estabelecimentos.isEmpty) {
          erro = 'Nenhum estabelecimento criado.';
        } else {
          erro = null;
        }
        loading = false;
      });
    } catch (e) {
      setState(() {
        erro = 'Erro ao carregar estabelecimentos';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estabelecimentos'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : erro != null
            ? Center(child: Text(erro!))
            : estabelecimentos.isEmpty
            ? const Center(child: Text('Nenhum estabelecimento encontrado.'))
            : ListView.separated(
                itemCount: estabelecimentos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  final est = estabelecimentos[index];
                  return CustomListItem(
                    title: est.name,
                    subtitle:
                        '${est.logradouro}, ${est.number} - CEP: ${est.CEP}',
                    imagePath: est.imageProfileUrl,
                    onEdit: () {
                      Navigator.pushNamed(
                        context,
                        '/edit-establishment/${est.id}',
                      ).then((_) {
                        buscarEstabelecimentos();
                      });
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/create-establishment');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey.shade400,
      ),
    );
  }
}
