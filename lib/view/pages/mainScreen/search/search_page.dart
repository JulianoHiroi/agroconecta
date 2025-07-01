import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/estabelecimentos_services.dart';
import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/produtos_services.dart';
import 'package:agroconecta/data/models/tipo_produto.dart';
import 'package:agroconecta/external/services/geolocator_service.dart';
import 'package:agroconecta/view/pages/mainScreen/settings/estabelecimentos/estabecimentos_page.dart';
import 'package:agroconecta/view/widgets/components/custom_droptdown_search.dart';
import 'package:agroconecta/view/widgets/components/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SearchMapPage extends StatefulWidget {
  const SearchMapPage({Key? key}) : super(key: key);

  @override
  State<SearchMapPage> createState() => _SearchMapPageState();
}

class _SearchMapPageState extends State<SearchMapPage> {
  final TextEditingController _searchController = TextEditingController();
  final mapController = MapController();

  final ProdutosServices produtosApi = ProdutosServices();
  final EstabelecimentosServices estabelecimentosApi =
      EstabelecimentosServices();

  List<Marker> _markers = [];

  String? _selectedTipoProduto;
  double _selectedRadius = 5;
  LatLng? _userLocation;

  bool _isLoading = false;

  List<TipoProduto> _tiposProdutos = [];

  void _loadTiposProduto() async {
    try {
      final response = await produtosApi.getAllTiposProdutos();
      setState(() {
        _tiposProdutos = response;
      });
    } catch (e) {
      print('Erro ao carregar tipos de produto: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _markers.clear(); // Limpa os marcadores ao limpar a busca
        });
      }
    });
    // Carrega os tipos de produto
    _loadTiposProduto();
    _getLocation(); // Obtém a localização do usuário ao iniciar
  }

  void _fitMarkersToView(List<LatLng> points) {
    if (points.isEmpty) return;

    var bounds = LatLngBounds.fromPoints(points);

    mapController.fitBounds(
      bounds,
      options: FitBoundsOptions(
        padding: const EdgeInsets.only(
          top: 120, // padding maior no topo para acomodar a barra de busca
          left: 60,
          right: 60,
          bottom: 60,
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      print('Localização do usuário: $position');

      final userLatLng = LatLng(position!.latitude, position.longitude);

      setState(() {
        _userLocation = userLatLng;
        print("Removendo marcadores antigos do usuário");
        _markers.removeWhere(
          (m) => m.key != null && m.key.toString().contains('user_location'),
        );
        print("Adicionando novo marcador do usuário");
        // E no marcador do usuário, adicione um identificador único:
        _markers.add(
          Marker(
            key: ValueKey('user_location'),
            point: userLatLng,
            width: 24,
            height: 24,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                color: Colors.green,
              ),
            ),
          ),
        );
      });

      // Move a câmera para o local do usuário
      mapController.move(userLatLng, 13.0);
    } catch (e) {
      print('Erro ao obter localização: $e');
    }
  }

  Future<void> _onSearch(String value) async {
    setState(() => _isLoading = true);

    await _getLocation();

    try {
      final estabelecimentosSelecionados = await estabelecimentosApi
          .searchEstabelecimento(
            lat: _userLocation?.latitude ?? -25.4442,
            lng: _userLocation?.longitude ?? -49.2104,
            name: value,
            idTypeProduct: _selectedTipoProduto ?? '',
            searchRadius: (_selectedRadius * 1000).toInt(),
          );

      setState(() {
        _markers.removeWhere((m) => m.key != const ValueKey('user_location'));

        _markers.addAll(
          estabelecimentosSelecionados.estabelecimentos.map((local) {
            return Marker(
              width: 100,
              height: 60,
              point: LatLng(local.latitude, local.longitude),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/select-establishment/${local.id}',
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 36),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        local.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );

        final allLatLngs = estabelecimentosSelecionados.estabelecimentos
            .map((local) => LatLng(local.latitude, local.longitude))
            .toList();

        if (_userLocation != null) {
          allLatLngs.add(_userLocation!);
        }
        print('Marcadores atualizados: ${_markers.length}');
        _fitMarkersToView(allLatLngs);
      });
    } catch (e) {
      print('Erro ao buscar estabelecimentos: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                //FAça a cor da modal ser branca
                padding: const EdgeInsets.all(16.0),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Filtros',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),
                    CustomDropdownSearch(
                      value: _selectedTipoProduto,
                      label: 'Tipo do Produto',
                      items: _tiposProdutos.map((tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo.id,
                          child: Text(tipo.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          _selectedTipoProduto = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),
                    Text('Raio: ${_selectedRadius.toStringAsFixed(0)} km'),
                    Slider(
                      value: _selectedRadius,
                      min: 1,
                      max: 200,
                      divisions: 49,
                      label: '${_selectedRadius.toStringAsFixed(0)} km',
                      onChanged: (value) {
                        setModalState(() => _selectedRadius = value);
                      },
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            label: 'Limpar',
                            onPressed: () {
                              setModalState(() {
                                _selectedTipoProduto = null;
                                _selectedRadius = 5;
                                _searchController
                                    .clear(); // se quiser limpar também o texto
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomElevatedButton(
                            label: 'Aplicar',
                            onPressed: () {
                              Navigator.pop(context);
                              _onSearch(_searchController.text);
                            },
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAPA
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: _userLocation ?? LatLng(-25.4442, -49.2104), // Pinhais-PR
              onTap: (_, __) => FocusScope.of(context).unfocus(),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),

          /// BARRA DE BUSCA + BOTÃO DE FILTRO
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: _onSearch,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _openFilter,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
