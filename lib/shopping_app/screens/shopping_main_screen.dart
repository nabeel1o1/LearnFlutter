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

  final List<GroceryItem> _groceryItems = groceryItems;

  late Future<List<GroceryItem>> _loadedItems;

  Future<List<GroceryItem>> _loadGroceryItems() async {
    final List<GroceryItem> loadedItems = [];

    final url = Uri.https(
        'flutter-prep-f57ce-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception(
          'Failed to fetch data from server. Please try again later');
    }

    if (response.body == 'null') {
      return [];
    }

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
    return loadedItems;
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

  void removeItem(GroceryItem groceryItem) async {
    final index = _groceryItems.indexOf(groceryItem);
    setState(() {
      _groceryItems.remove(groceryItem);
    });
    final url = Uri.https('flutter-prep-f57ce-default-rtdb.firebaseio.com',
        'shopping-list/${groceryItem.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to delete the data.'),
            action: SnackBarAction(
              label: 'Try Again',
              onPressed: () {
                removeItem(groceryItem);
              },
            ),
          ),
        );
      }
      setState(() {
        _groceryItems.insert(index, groceryItem);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadGroceryItems();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapShot.hasError) {
            return Center(
              child: Text(
                snapShot.error.toString(),
              ),
            );
          }
          if (snapShot.data!.isEmpty) {
            return const Center(
              child: Text('No items added yet'),
            );
          }

          return ListView.builder(
            itemCount: snapShot.data!.length,
            itemBuilder: (ctx, index) {
              return Dismissible(
                key: ValueKey(snapShot.data![index].id),
                onDismissed: (direction) {
                  removeItem(snapShot.data![index]);
                },
                child: ListTile(
                  title: Text(snapShot.data![index].name),
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: snapShot.data![index].category.color,
                  ),
                  trailing: Text(
                    snapShot.data![index].quantity.toString(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
