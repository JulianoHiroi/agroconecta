import 'package:agroconecta/database/repositories/item/item.repository.dart';
import 'package:agroconecta/router/router.dart';
import 'package:agroconecta/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:agroconecta/models/item.dart';

class PageItens extends StatefulWidget {
  final PageNotifier pageNotifier;
  const PageItens({required this.pageNotifier, super.key});

  @override
  State<PageItens> createState() => _PageItensState();
}

class _PageItensState extends State<PageItens> {
  final ItemRepository _repository = ItemRepository();
  List<Item> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _repository.getAllItems();
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ItemListTile(
                  item: item,
                  pageNotifier: widget.pageNotifier,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to a page to add a new item
          // This is just a placeholder, implement your own navigation logic
          final newItem = Item(
            id: DateTime.now().toString(), // Generate a unique ID
            name: 'New Item ${_items.length + 1}',
            description: 'Description for new item',
          );
          try {
            await _repository.insertItem(newItem);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Item "${newItem.name}" added')),
            );
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error adding item: $e')));
          }
          _loadItems(); // Reload items after adding a new one
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Width que será o item da lista de itens
class ItemListTile extends StatelessWidget {
  final PageNotifier pageNotifier;
  final Item item;

  const ItemListTile({
    super.key,
    required this.item,
    required this.pageNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return // Retorne um componente que tenha a descrição e o nome do item e ao lado direito um botão para ver os detalhes do item
    ListTile(
      title: Text(item.name),
      subtitle: Text(item.description),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // Navigate to item details page
          pageNotifier.changePage(page: PageName.itens, itemId: item.id);
        },
      ),
    );
  }
}

class PageItensDetail extends StatefulWidget {
  final String id;

  const PageItensDetail({super.key, required this.id});

  @override
  State<PageItensDetail> createState() => _PageItensDetailState();
}

class _PageItensDetailState extends State<PageItensDetail> {
  final ItemRepository _repository = ItemRepository();
  Item? _item;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  Future<void> _loadItem() async {
    final item = await _repository.getItemById(widget.id);
    setState(() {
      _item = item;
      _isLoading = false;
    });
  }

  void showForms() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: TextEditingController(text: _item?.name),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                controller: TextEditingController(text: _item?.description),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Save the edited item
                if (_item != null) {
                  _repository
                      .updateItem(
                        Item(
                          id: _item!.id,
                          name: 'Edited Name', // Replace with actual input
                          description:
                              'Edited Description', // Replace with actual input
                        ),
                      )
                      .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item "${_item!.name}" updated'),
                          ),
                        );
                        Navigator.of(context).pop();
                        _loadItem(); // Reload item after editing
                      })
                      .catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating item: $e')),
                        );
                      });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item not found')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _item != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${_item!.name}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Description: ${_item!.description}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // fAÇA COM QUE APARECA UM FORMULARIO ABAIXO PARA EDITAR O ITEM
                      showForms();
                    },
                    child: const Text('Edit Item'),
                  ),
                ],
              ),
            )
          : const Center(child: Text('Item not found')),
    );
  }
}
