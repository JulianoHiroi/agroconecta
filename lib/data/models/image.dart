import 'package:agroconecta/core/constants/configuration.dart';

class Image {
  final String id;
  final String url;

  Image({required this.id, required this.url});

  String get fullUrl => '${Configuration.routeImages}$url';

  factory Image.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    // Verifique se imageProfileUrl está presente e não é nulo
    if (json['url'] != null) {
      imageUrl = '${Configuration.routeImages}${json['url']}';
    }

    return Image(id: json['id'], url: imageUrl ?? '');
  }
}
