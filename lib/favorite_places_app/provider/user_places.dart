import 'dart:io';

import 'package:flutteroid_app/favorite_places_app/models/place.dart';
import 'package:riverpod/riverpod.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title, File image) {
    final newPlace = Place(title: title, image: image);
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
