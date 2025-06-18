import 'package:agroconecta/models/item.dart';

abstract class ItemRepositoryBase {
  Future<void> insertItem(Item item);
  Future<List<Item>> getAllItems();
  Future<Item?> getItemById(String id);
  Future<void> updateItem(Item item);
  Future<void> deleteItem(String id);
}
