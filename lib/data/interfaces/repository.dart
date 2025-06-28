import 'package:agroconecta/data/models/item.dart';
import 'package:agroconecta/data/models/user.dart';

abstract class ItemRepositoryBase {
  Future<void> insertItem(Item item);
  Future<List<Item>> getAllItems();
  Future<Item?> getItemById(String id);
  Future<void> updateItem(Item item);
  Future<void> deleteItem(String id);
}

abstract class UserRepositoryBase {
  Future<void> insertUser(User user);
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(String id);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String id);
}
