// ignore_for_file: constant_identifier_names

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

  static const SQLITE_TABLE_NAME = 'items';
  static const SQLITE_COLUMN_ID = 'id';
  static const SQLITE_COLUMN_NAME = 'name';
  static const SQLITE_COLUMN_DESCRIPTION = 'description';
  static const SQLITE_CREATE_TABLE =
      '''
    CREATE TABLE $SQLITE_TABLE_NAME (
      $SQLITE_COLUMN_ID TEXT PRIMARY KEY,
      $SQLITE_COLUMN_NAME TEXT NOT NULL,
      $SQLITE_COLUMN_DESCRIPTION TEXT NOT NULL
    )
  ''';
  static const SQLITE_DROP_TABLE = 'DROP TABLE IF EXISTS $SQLITE_TABLE_NAME';
}
