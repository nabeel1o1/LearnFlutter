import 'package:flutter/material.dart';
import 'package:flutteroid_app/favorite_places_app/models/place.dart';
import 'package:flutteroid_app/favorite_places_app/screens/places_detail_screen.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    return places.isEmpty
        ? const Center(
            child: Text('No places added yet'),
          )
        : ListView.builder(
            itemCount: places.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(places[index].image),
                ),
                title: Text(
                  places[index].title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return PlacesDetailScreen(place: places[index]);
                      },
                    ),
                  );
                },
              );
            },
          );
  }
}
