/*
[
    {
        "id": "1136f230-70f1-41f3-af01-759ae50ee4bf",
        "price": 12.5,
        "description": "Pepino fresco colhido hoje pela manhã",
        "idTypeProduct": "5a1eb127-0ed4-4a35-ba37-6800d6339355",
        "name": "Pepino"
    }
]

Sabendo que essse é o JSON de um produto, crie a classe Produto que represente esse JSON.
 */

class Produto {
  final String id;
  final double price;
  final String description;
  final String idTypeProduct;
  final String name;
  final double? quantity;

  Produto({
    required this.id,
    required this.price,
    required this.description,
    required this.idTypeProduct,
    required this.name,
    this.quantity,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      idTypeProduct: json['idTypeProduct'] as String,
      name: json['name'] as String,
      quantity: json.containsKey('quantity')
          ? (json['quantity'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'description': description,
      'idTypeProduct': idTypeProduct,
      'name': name,
      if (quantity != null) 'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'Produto{id: $id, price: $price, description: $description, idTypeProduct: $idTypeProduct, name: $name, quantity: $quantity}';
  }
}
