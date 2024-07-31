import 'package:flutter/material.dart';
import 'package:flutteroid_app/grocery_app/data/dummy_items.dart';
import 'package:flutteroid_app/grocery_app/models/grocery_item.dart';
import 'package:flutteroid_app/grocery_app/screens/add_grocery_item_screen.dart';

class GroceryMainScreen extends StatefulWidget {
  const GroceryMainScreen({super.key});

  @override
  State<GroceryMainScreen> createState() => _GroceryMainScreenState();
}

class _GroceryMainScreenState extends State<GroceryMainScreen> {
  final List<GroceryItem> _groceryItems = groceryItems;

  void addGroceryItem() async {
    final newGroceryItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const AddGroceryItemScreen()));

    if (newGroceryItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newGroceryItem);
    });
  }

  void removeItem(GroceryItem groceryItem) {
    setState(() {
      _groceryItems.remove(groceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet'),
    );
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (direction) {
              removeItem(_groceryItems[index]);
            },
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(
                _groceryItems[index].quantity.toString(),
              ),
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: addGroceryItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
