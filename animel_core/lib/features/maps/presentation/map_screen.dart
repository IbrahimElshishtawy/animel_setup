import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../home/logic/animal_bloc.dart';
import '../../adoption/logic/adoption_bloc.dart';
import '../../../core/models/animal_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(40.7128, -74.0060); // Default to NY

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> _createMarkers(List<Animal> saleAnimals, List<Animal> adoptionAnimals) {
    Set<Marker> markers = {};

    for (var animal in saleAnimals) {
      if (animal.latitude != 0 && animal.longitude != 0) {
        markers.add(
          Marker(
            markerId: MarkerId('sale_${animal.id}'),
            position: LatLng(animal.latitude, animal.longitude),
            infoWindow: InfoWindow(
              title: animal.name,
              snippet: '${animal.breed} - \$${animal.price}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          ),
        );
      }
    }

    for (var animal in adoptionAnimals) {
      if (animal.latitude != 0 && animal.longitude != 0) {
        markers.add(
          Marker(
            markerId: MarkerId('adopt_${animal.id}'),
            position: LatLng(animal.latitude, animal.longitude),
            infoWindow: InfoWindow(
              title: animal.name,
              snippet: '${animal.breed} - For Adoption',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      }
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Animals'),
      ),
      body: BlocBuilder<AnimalBloc, AnimalState>(
        builder: (context, animalState) {
          return BlocBuilder<AdoptionBloc, AdoptionState>(
            builder: (context, adoptionState) {
              List<Animal> saleAnimals = [];
              List<Animal> adoptionAnimals = [];

              if (animalState is AnimalLoaded) {
                saleAnimals = animalState.animals;
              }
              if (adoptionState is AdoptionLoaded) {
                adoptionAnimals = adoptionState.animals;
              }

              return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: _createMarkers(saleAnimals, adoptionAnimals),
              );
            },
          );
        },
      ),
    );
  }
}
