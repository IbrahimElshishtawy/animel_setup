// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../adoption/logic/adoption_bloc.dart';
import '../../home/logic/animal_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _fallbackCenter = LatLng(30.0444, 31.2357);

  GoogleMapController? _mapController;
  LatLng _currentCenter = _fallbackCenter;
  _MapFilter _activeFilter = _MapFilter.all;
  bool _isLoadingLocation = true;
  bool _hasLocationPermission = false;
  bool _isResultsPanelVisible = false;
  String _areaLabel = 'Cairo community area';
  String? _selectedPointId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    final animalBloc = context.read<AnimalBloc>();
    final adoptionBloc = context.read<AdoptionBloc>();


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

    if (animalBloc.state is AnimalInitial || animalBloc.state is AnimalError) {
      animalBloc.add(FetchAnimals());
    }

    if (adoptionBloc.state is AdoptionInitial || adoptionBloc.state is AdoptionError) {
      adoptionBloc.add(FetchAdoptionAnimals());
    }

    await _loadCurrentLocation();
  }}

  Future<void> _loadCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _isLoadingLocation = false;
          _areaLabel = 'Location service is off, showing Cairo area';
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _isLoadingLocation = false;
          _hasLocationPermission = false;
          _areaLabel = 'Enable location to find points near you';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final target = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentCenter = target;
        _isLoadingLocation = false;
        _hasLocationPermission = true;
        _areaLabel = _describeArea(target);
      });

      _animateTo(target, zoom: 13.2);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
        _hasLocationPermission = false;
        _areaLabel = 'Showing nearby sample points around Cairo';
      });
    }
  }

  String _describeArea(LatLng center) {
    if (center.latitude > 29.8 &&
        center.latitude < 30.2 &&
        center.longitude > 31.0 &&
        center.longitude < 31.5) {
      return 'Nearby in Cairo';
    }
    return 'Nearby around your current area';
  }

  Future<void> _animateTo(LatLng target, {double zoom = 13.2}) async {
    final controller = _mapController;
    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }

  LatLng _shift(LatLng origin, double latDelta, double lngDelta) {
    return LatLng(origin.latitude + latDelta, origin.longitude + lngDelta);
  }

  List<_MapPoint> _buildSalePoints(List<Animal> animals) {
    const offsets = [
      Offset(0.010, 0.006),
      Offset(-0.008, 0.010),
      Offset(0.006, -0.009),
      Offset(-0.011, -0.004),
      Offset(0.013, -0.002),
    ];

    return List.generate(animals.length, (index) {
      final animal = animals[index];
      final offset = offsets[index % offsets.length];
      return _MapPoint(
        id: 'sale_${animal.id}',
        kind: _MapPointKind.sale,
        title: animal.name,
        subtitle: '${animal.breed} - ${animal.location}',
        distanceLabel: '${1.2 + (index * 0.6)} km away',
        position: _shift(_currentCenter, offset.dx, offset.dy),
        accent: const Color(0xFFE27D60),
        animal: animal,
      );
    });
  }

  List<_MapPoint> _buildAdoptionPoints(List<Animal> animals) {
    const offsets = [
      Offset(0.004, 0.014),
      Offset(-0.012, 0.006),
      Offset(0.009, -0.012),
      Offset(-0.006, -0.014),
    ];

    return List.generate(animals.length, (index) {
      final animal = animals[index];
      final offset = offsets[index % offsets.length];
      return _MapPoint(
        id: 'adoption_${animal.id}',
        kind: _MapPointKind.adoption,
        title: animal.name,
        subtitle: '${animal.breed} - Ready for adoption',
        distanceLabel: '${0.9 + (index * 0.7)} km away',
        position: _shift(_currentCenter, offset.dx, offset.dy),
        accent: const Color(0xFF3E9D6C),
        animal: animal,
      );
    });
  }

  List<_MapPoint> _buildPeoplePoints() {
    final people = [
      _NearbyPerson(
        id: 'person_1',
        name: 'Mona Ali',
        role: 'Adoption coordinator',
        area: 'Same district',
        accent: const Color(0xFF4B8FA5),
        offset: const Offset(0.003, -0.005),
      ),
      _NearbyPerson(
        id: 'person_2',
        name: 'Omar Hassan',
        role: 'Pet transporter',
        area: '1.1 km away',
        accent: const Color(0xFF7C4D9E),
        offset: const Offset(-0.004, 0.003),
      ),
      _NearbyPerson(
        id: 'person_3',
        name: 'Sara Nabil',
        role: 'Local rescuer',
        area: 'Same area',
        accent: const Color(0xFFDA6C56),
        offset: const Offset(0.007, 0.001),
      ),
      _NearbyPerson(
        id: 'person_4',
        name: 'Dr. Karim',
        role: 'Vet support',
        area: '1.8 km away',
        accent: const Color(0xFF3E9D6C),
        offset: const Offset(-0.007, -0.007),
      ),
    ];

    return people
        .map(
          (person) => _MapPoint(
            id: person.id,
            kind: _MapPointKind.person,
            title: person.name,
            subtitle: '${person.role} - ${person.area}',
            distanceLabel: person.area,
            position: _shift(_currentCenter, person.offset.dx, person.offset.dy),
            accent: person.accent,
            person: person,
          ),
        )
        .toList();
  }

  List<_MapPoint> _applyFilter(List<_MapPoint> points) {
    switch (_activeFilter) {
      case _MapFilter.sale:
        return points.where((point) => point.kind == _MapPointKind.sale).toList();
      case _MapFilter.adoption:
        return points.where((point) => point.kind == _MapPointKind.adoption).toList();
      case _MapFilter.people:
        return points.where((point) => point.kind == _MapPointKind.person).toList();
      case _MapFilter.all:
        return points;
    }
  }

  double _markerHue(_MapPointKind kind) {
    switch (kind) {
      case _MapPointKind.sale:
        return BitmapDescriptor.hueOrange;
      case _MapPointKind.adoption:
        return BitmapDescriptor.hueGreen;
      case _MapPointKind.person:
        return BitmapDescriptor.hueAzure;
    }
  }

  Set<Marker> _buildMarkers(List<_MapPoint> points) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('my_location'),
        position: _currentCenter,
        infoWindow: const InfoWindow(title: 'Your area'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    };

    for (final point in points) {
      markers.add(
        Marker(
          markerId: MarkerId(point.id),
          position: point.position,
          infoWindow: InfoWindow(
            title: point.title,
            snippet: point.subtitle,
          ),
          onTap: () {
            setState(() => _selectedPointId = point.id);
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(_markerHue(point.kind)),
        ),
      );
>>>>>>> Stashed changes
    }

    return markers;
  }

  void _focusPoint(_MapPoint point) {
    setState(() => _selectedPointId = point.id);
    _animateTo(point.position, zoom: 14.4);
  }

  void _openPoint(_MapPoint point) {
    if (point.kind == _MapPointKind.person && point.person != null) {
      context.push('/chat-detail', extra: point.person!.name);
      return;
    }

    if (point.kind == _MapPointKind.adoption && point.animal != null) {
      context.push('/adoption-details', extra: point.animal);
      return;
    }

    if (point.animal != null) {
      context.push('/animal-details', extra: point.animal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F7),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      body: BlocBuilder<AnimalBloc, AnimalState>(
        builder: (context, animalState) {
          return BlocBuilder<AdoptionBloc, AdoptionState>(
            builder: (context, adoptionState) {
              final saleAnimals =
                  animalState is AnimalLoaded ? animalState.animals : <Animal>[];
              final adoptionAnimals = adoptionState is AdoptionLoaded
                  ? adoptionState.animals
                  : <Animal>[];

              final peoplePoints = _buildPeoplePoints();
              final allPoints = [
                ..._buildSalePoints(saleAnimals),
                ..._buildAdoptionPoints(adoptionAnimals),
                ...peoplePoints,
              ];

              final visiblePoints = _applyFilter(allPoints);
              final panelHeight = _isResultsPanelVisible ? 286.0 : 56.0;
              final floatingButtonsBottom = _isResultsPanelVisible ? 300.0 : 120.0;
              _MapPoint? selectedPoint;
              if (visiblePoints.isNotEmpty) {
                final selectedMatch = visiblePoints.where(
                  (point) => point.id == _selectedPointId,
                );
                selectedPoint =
                    selectedMatch.isNotEmpty ? selectedMatch.first : visiblePoints.first;
              }

              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentCenter,
                      zoom: 12.4,
                    ),
                    myLocationEnabled: _hasLocationPermission,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    onTap: (_) => setState(() => _selectedPointId = null),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _animateTo(_currentCenter, zoom: 12.4);
                    },
                    markers: _buildMarkers(visiblePoints),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Column(
                        children: [
                          _MapTopCard(
                            areaLabel: _areaLabel,
                            isLoadingLocation: _isLoadingLocation,
                            saleCount: saleAnimals.length,
                            adoptionCount: adoptionAnimals.length,
                            peopleCount: peoplePoints.length,
                            onLocate: _loadCurrentLocation,
                          ),
                          const SizedBox(height: 12),
                          _MapFilterBar(
                            activeFilter: _activeFilter,
                            onChanged: (filter) {
                              setState(() => _activeFilter = filter);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: floatingButtonsBottom + 56,
                    child: _MapFloatingButton(
                      icon: Icons.my_location_rounded,
                      onTap: _loadCurrentLocation,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: floatingButtonsBottom,
                    child: _MapFloatingButton(
                      icon: Icons.layers_outlined,
                      onTap: () {
                        setState(() {
                          _activeFilter = _activeFilter == _MapFilter.all
                              ? _MapFilter.people
                              : _MapFilter.all;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: panelHeight,
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 92),
                      padding: EdgeInsets.fromLTRB(
                        16,
                        _isResultsPanelVisible ? 12 : 10,
                        16,
                        _isResultsPanelVisible ? 16 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.97),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFE9DCE7)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x184B1A45),
                            blurRadius: 28,
                            offset: Offset(0, 14),
                          ),
                        ],
                      ),
                      child: _isResultsPanelVisible
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isResultsPanelVisible = false;
                                      });
                                    },
                                    child: SizedBox(
                                      height: 12,
                                      child: Center(
                                        child: Container(
                                          width: 42,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD6C7D1),
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Nearby in your area',
                                        style: TextStyle(
                                          color: Color(0xFF2F1B2D),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${visiblePoints.length} results',
                                      style: const TextStyle(
                                        color: Color(0xFF8B7B88),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selectedPoint == null
                                      ? 'Animals, adopters, and nearby helpers around the same location.'
                                      : 'Focused on ${selectedPoint.title}. Tap the card action to continue.',
                                  style: const TextStyle(
                                    color: Color(0xFF8B7B88),
                                    fontSize: 12.5,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: visiblePoints.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'No nearby points in this filter yet.',
                                            style: TextStyle(
                                              color: Color(0xFF8B7B88),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: visiblePoints.length,
                                          separatorBuilder: (_, _) =>
                                              const SizedBox(width: 10),
                                          itemBuilder: (context, index) {
                                            final point = visiblePoints[index];
                                            return _NearbyMapCard(
                                              point: point,
                                              isSelected: point.id == selectedPoint?.id,
                                              onTap: () => _focusPoint(point),
                                              onAction: () => _openPoint(point),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            )
                          : InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () {
                                setState(() {
                                  _isResultsPanelVisible = true;
                                });
                              },
                              child: SizedBox(
                                height: 36,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3EAF1),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: const Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        color: Color(0xFF4B1A45),
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Nearby points hidden',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Color(0xFF2F1B2D),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Show',
                                      style: TextStyle(
                                        color: Color(0xFF8B7B88),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
<<<<<<< Updated upstream
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
=======
    );
  }
}

enum _MapFilter { all, sale, adoption, people }

enum _MapPointKind { sale, adoption, person }

class _MapPoint {
  const _MapPoint({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.distanceLabel,
    required this.position,
    required this.accent,
    this.animal,
    this.person,
  });

  final String id;
  final _MapPointKind kind;
  final String title;
  final String subtitle;
  final String distanceLabel;
  final LatLng position;
  final Color accent;
  final Animal? animal;
  final _NearbyPerson? person;

  String get actionLabel {
    switch (kind) {
      case _MapPointKind.sale:
        return 'View animal';
      case _MapPointKind.adoption:
        return 'Open adoption';
      case _MapPointKind.person:
        return 'Start chat';
    }
  }

  String get badgeLabel {
    switch (kind) {
      case _MapPointKind.sale:
        return 'For sale';
      case _MapPointKind.adoption:
        return 'Adoption';
      case _MapPointKind.person:
        return 'Nearby helper';
    }
  }

  IconData get icon {
    switch (kind) {
      case _MapPointKind.sale:
        return Icons.sell_outlined;
      case _MapPointKind.adoption:
        return Icons.favorite_border_rounded;
      case _MapPointKind.person:
        return Icons.person_pin_circle_outlined;
    }
  }
}

class _NearbyPerson {
  const _NearbyPerson({
    required this.id,
    required this.name,
    required this.role,
    required this.area,
    required this.accent,
    required this.offset,
  });

  final String id;
  final String name;
  final String role;
  final String area;
  final Color accent;
  final Offset offset;
}

class _MapTopCard extends StatelessWidget {
  const _MapTopCard({
    required this.areaLabel,
    required this.isLoadingLocation,
    required this.saleCount,
    required this.adoptionCount,
    required this.peopleCount,
    required this.onLocate,
  });

  final String areaLabel;
  final bool isLoadingLocation;
  final int saleCount;
  final int adoptionCount;
  final int peopleCount;
  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF4B1A45), Color(0xFF7B315E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x194B1A45),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Community map',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onLocate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.gps_fixed_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Professional nearby map for animals and people in the same area.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            areaLabel,
            style: TextStyle(
              color: Colors.white.withOpacity(0.84),
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MapStat(value: '$saleCount', label: 'Sale points'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MapStat(value: '$adoptionCount', label: 'Adoption'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MapStat(value: '$peopleCount', label: 'Helpers'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapStat extends StatelessWidget {
  const _MapStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapFilterBar extends StatelessWidget {
  const _MapFilterBar({
    required this.activeFilter,
    required this.onChanged,
  });

  final _MapFilter activeFilter;
  final ValueChanged<_MapFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = [
      (_MapFilter.all, 'All', Icons.grid_view_rounded),
      (_MapFilter.sale, 'Sale', Icons.sell_outlined),
      (_MapFilter.adoption, 'Adopt', Icons.favorite_border_rounded),
      (_MapFilter.people, 'People', Icons.group_outlined),
    ];

    return Container(
      height: 52,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9DCE7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x104B1A45),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (filter, label, icon) = filters[index];
          final isSelected = filter == activeFilter;

          return InkWell(
            onTap: () => onChanged(filter),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: isSelected ? const Color(0xFF4B1A45) : const Color(0xFFF8F2F6),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected ? Colors.white : const Color(0xFF715F6B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF715F6B),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NearbyMapCard extends StatelessWidget {
  const _NearbyMapCard({
    required this.point,
    required this.isSelected,
    required this.onTap,
    required this.onAction,
  });

  final _MapPoint point;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 206,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8F1F6) : const Color(0xFFFCFAFC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? point.accent.withOpacity(0.45) : const Color(0xFFECE1E9),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: point.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(point.icon, color: point.accent, size: 18),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF2F1B2D),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        point.distanceLabel,
                        style: const TextStyle(
                          color: Color(0xFF8B7B88),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: point.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                point.badgeLabel,
                style: TextStyle(
                  color: point.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                point.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF6F5C69),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B1A45),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(32),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  point.actionLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFloatingButton extends StatelessWidget {
  const _MapFloatingButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE9DCE7)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x154B1A45),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF4B1A45)),
        ),
>>>>>>> Stashed changes
      ),
    );
  }
}
