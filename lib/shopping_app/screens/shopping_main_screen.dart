import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutteroid_app/shopping_app/data/categories.dart';
import 'package:flutteroid_app/shopping_app/data/dummy_items.dart';
import 'package:flutteroid_app/shopping_app/models/grocery_item.dart';
import 'package:flutteroid_app/shopping_app/screens/add_new_item_screen.dart';
import 'package:http/http.dart' as http;

class ShoppingMainScreen extends StatefulWidget {
  const ShoppingMainScreen({super.key});

  @override
  State<ShoppingMainScreen> createState() => _ShoppingMainScreenState();
}

class _ShoppingMainScreenState extends State<ShoppingMainScreen> {
  List<GroceryItem> _groceryItems = groceryItems;

  var _isLoading = true;

  void _loadGroceryItems() async {
    final List<GroceryItem> loadedItems = [];

    final url = Uri.https(
        'flutter-prep-f57ce-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);

    final Map<String, dynamic> dataList = json.decode(response.body);

    for (final item in dataList.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  void addGroceryItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const AddNewItemScreen()));

    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void removeItem(GroceryItem groceryItem) {
    setState(() {
      _groceryItems.remove(groceryItem);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadGroceryItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

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
