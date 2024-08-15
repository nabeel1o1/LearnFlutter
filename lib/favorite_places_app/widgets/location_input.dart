import 'package:flutter/material.dart';
import 'package:flutteroid_app/favorite_places_app/models/place.dart';
import 'package:flutteroid_app/favorite_places_app/screens/map_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;

class LocationInput extends StatefulWidget {
  const LocationInput({required this.onSelectLocation, super.key});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? currentAddress;

  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  void _getAddressFromLatLng(double lat, double long) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);

    if (placeMarks.isNotEmpty) {
      setState(() {
        currentAddress = placeMarks[0].toString();

        _pickedLocation = PlaceLocation(
            latitude: lat, longitude: long, address: currentAddress!);
        _isGettingLocation = false;

        widget.onSelectLocation(_pickedLocation!);
      });
    }
  }

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
      _getAddressFromLatLng(lat, long);
    } else {
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }
  }

  void _getLocationViaMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) {
          return const MapScreen();
        },
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _isGettingLocation = true;
      });

      _getAddressFromLatLng(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );
    }
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

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 170,
          ),
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
                onPressed: _getLocationViaMap),
          ],
        ),
      ],
    );
  }
}
