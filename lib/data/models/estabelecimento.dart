// faça a classe sabendo que o estabelecimento tera os seguintes campos:
/*
 {
        "id": "7e375c69-87c7-48db-a843-94cc8f3cd928",
        "name": "Mercado São João",
        "logradouro": "Rua Euclides da C2131231unha Ribas",
        "latitue": -25.402199,
        "longitude": -49.18351269999999,
        "imageProfileUrl": "273be006f160-cart.png",
        "number": "70",
        "CEP": "83326-17021",
        "phone": "(41) 99999-1234",
        "description": "Mercado local com produtos frescos todos os dias."
    }
*/
import 'package:agroconecta/core/constants/configuration.dart';
import 'package:agroconecta/data/models/image.dart';
import 'package:agroconecta/data/models/produto.dart';

class Estabelecimento {
  final String id;
  final String name;
  final String logradouro;
  final double? latitude;
  final double? longitude;
  final String? imageProfileUrl;
  final String number;
  final String CEP;
  final String phone;
  final String? description;
  final List<Image>? images;
  final List<Produto>? produtos;

  Estabelecimento({
    required this.id,
    required this.name,
    required this.logradouro,
    required this.latitude,
    required this.longitude,
    required this.imageProfileUrl,
    required this.number,
    required this.CEP,
    required this.phone,
    required this.description,
    this.images,
    this.produtos,
  });

  factory Estabelecimento.fromJson(Map<String, dynamic> json) {
    // print o id do estabelecimento
    print('Estabelecimento ID: ${json['id']}');

    String? imageProfileUrl;
    // Verifique se imageProfileUrl está presente e não é nulo
    if (json['imageProfileUrl'] != null) {
      imageProfileUrl =
          '${Configuration.routeImages}${json['imageProfileUrl']}';
    }

    return Estabelecimento(
      id: json['id'],
      name: json['name'],
      logradouro: json['logradouro'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageProfileUrl: imageProfileUrl,
      number: json['number'],
      CEP: json['CEP'],
      phone: json['phone'],
      description: json['description'],
      images: (json['images'] as List<dynamic>?)
          ?.map((image) => Image.fromJson(image as Map<String, dynamic>))
          .toList(),
      produtos: (json['products'] as List<dynamic>?)
          ?.map((produto) => Produto.fromJson(produto as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logradouro': logradouro,
      'latitude': latitude,
      'longitude': longitude,
      'imageProfileUrl': imageProfileUrl,
      'number': number,
      'CEP': CEP,
      'phone': phone,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Estabelecimento{id: $id, name: $name, logradouro: $logradouro, latitude: $latitude, longitude: $longitude, imageProfileUrl: $imageProfileUrl, number: $number, cep: $CEP, phone: $phone, description: $description}'
        '${images != null ? ', images: ${images!.map((image) => image.toString()).join(', ')}' : ''}'
        '${produtos != null ? ', produtos: ${produtos!.map((produto) => produto.toString()).join(', ')}' : ''}';
  }
}
