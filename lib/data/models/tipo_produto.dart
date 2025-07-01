/*
[
    {
        "id": "5a1eb127-0ed4-4a35-ba37-6800d6339355",
        "name": "Pepino"
    },
    {
*/

class TipoProduto {
  final String id;
  final String name;

  TipoProduto({required this.id, required this.name});

  factory TipoProduto.fromJson(Map<String, dynamic> json) {
    return TipoProduto(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'TipoProduto{id: $id, name: $name}';
  }
}
