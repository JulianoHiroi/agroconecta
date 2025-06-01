class Item {
  final String id;
  final String name;
  final String description;

  Item({required this.id, required this.name, required this.description});

  @override
  String toString() {
    return 'Item{id: $id, name: $name, description: $description}';
  }

  // Metodos para converter o objeto para json e de json para objeto
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  static List<Item> generateItems(int count) {
    return List<Item>.generate(
      count,
      (index) => Item(
        id: 'item_$index',
        name: 'Item $index',
        description: 'Description for item $index',
      ),
    );
  }
}
