import 'package:flutter/material.dart';
import 'package:flutteroid_app/favorite_places_app/models/place.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    double lat = _pickedLocation!.latitude;
    double long = _pickedLocation!.longitude;
    return 'https://api.maptiler.com/maps/streets-v2/static/$lat,$long,1.154818109052104/400x300.png?key=0oiYhR6bkYDwUSwIf0dn';
  }

  String? currentAddress;

  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  void _getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat != null && long != null) {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);

      if (placeMarks.isNotEmpty) {
        currentAddress = placeMarks[0].toString();
      }
    } else {
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: lat, longitude: long, address: currentAddress!);
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      currentAddress ?? 'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current location'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Select on Map'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
