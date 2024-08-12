import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutteroid_app/favorite_places_app/provider/user_places.dart';
import 'package:flutteroid_app/favorite_places_app/widgets/image_input.dart';
import 'package:flutteroid_app/favorite_places_app/widgets/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();

  File? _selectedImage;

  void _addPlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty || _selectedImage == null) {
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(
              height: 5,
            ),
            ImageInput(
              onSelectImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            const LocationInput(),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: _addPlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            )
          ],
        ),
      ),
    );
  }
}
