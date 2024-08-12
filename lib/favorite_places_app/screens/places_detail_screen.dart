import 'package:flutter/material.dart';
import 'package:flutteroid_app/favorite_places_app/models/place.dart';

class PlacesDetailScreen extends StatelessWidget {
  const PlacesDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Center(
          child: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      )),
    );
  }
}
