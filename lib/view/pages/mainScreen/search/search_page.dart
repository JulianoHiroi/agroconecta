import 'package:agroconecta/data/datasource/remote/agroConectaApi/services/produtos_services.dart';
import 'package:agroconecta/data/models/tipo_produto.dart';
import 'package:agroconecta/external/services/geolocator_service.dart';
import 'package:agroconecta/view/widgets/components/custom_droptdown_search.dart';
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

  List<Marker> _markers = [];

  String? _selectedTipoProduto;
  double _selectedRadius = 5;
  LatLng? _userLocation;

  List<TipoProduto> _tiposProdutos = [];

  void _loadTiposProduto() async {
    try {
      final response = await produtosApi.getAllTiposProdutos();
      setState(() {
        _tiposProdutos = response;
        print('Tipos de produto carregados: ${_tiposProdutos.length}');
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

  void _getLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      print('Localização do usuário: $position');

      final userLatLng = LatLng(position!.latitude, position.longitude);

      setState(() {
        _userLocation = userLatLng;

        // Adiciona ou atualiza marcador do usuário (como uma bolinha verde)
        _markers.removeWhere((m) => m.key == const ValueKey('user_location'));

        _markers.add(
          Marker(
            key: const ValueKey('user_location'),
            point: userLatLng,
            width: 20,
            height: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
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
    print('Buscando por: $value');
    print('Tipo de Produto: $_selectedTipoProduto');
    print('Raio: ${_selectedRadius.toStringAsFixed(0)} km');
    print('Localização do usuário: $_userLocation');

    // Mock com localização de Pinhas-PR e arredores
    final mockResults = [
      {'name': 'Feira Pinhas', 'lat': -25.4442, 'lng': -49.2104},
      {'name': 'Mercado Central', 'lat': -25.4430, 'lng': -49.2180},
      {'name': 'Empório Rural', 'lat': -25.4487, 'lng': -49.2022},
    ];

    setState(() {
      // Remove todos os marcadores que não são do usuário
      _markers.removeWhere((m) => m.key != const ValueKey('user_location'));

      _markers.addAll(
        mockResults.map((local) {
          return Marker(
            width: 40,
            height: 40,
            point: LatLng(local['lat'] as double, local['lng'] as double),
            child: Tooltip(
              message: local['name'] as String,
              child: const Icon(Icons.location_on, color: Colors.red, size: 36),
            ),
          );
        }).toList(),
      );

      if (mockResults.isNotEmpty) {
        mapController.move(
          LatLng(
            mockResults[0]['lat'] as double,
            mockResults[0]['lng'] as double,
          ),
          14.0,
        );
      }
    });
  }

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              //FAça a cor da modal ser branca
              padding: const EdgeInsets.all(16.0),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      setState(() {
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _onSearch(
                        _searchController.text,
                      ); // Refaz a busca com filtros aplicados
                    },
                    child: const Text('Aplicar Filtros'),
                  ),
                ],
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
              center: LatLng(-23.5505, -46.6333),
              zoom: 13.0,
              maxZoom: 18.0,
              minZoom: 2.0,
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
        ],
      ),
    );
  }
}
