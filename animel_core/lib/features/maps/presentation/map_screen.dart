// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/theme/app_tokens.dart';
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
  static const MethodChannel _mapsConfigChannel = MethodChannel(
    'animel_core/maps_config',
  );

  GoogleMapController? _mapController;
  LatLng _currentCenter = _fallbackCenter;
  _MapFilter _activeFilter = _MapFilter.all;
  bool _isLoadingLocation = true;
  bool _hasLocationPermission = false;
  bool _hasValidMapsApiKey = true;
  bool _isResultsPanelVisible = false;
  String _areaLabel = 'Cairo community area';
  String? _mapsConfigurationHint;
  String? _selectedPointId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final animalBloc = context.read<AnimalBloc>();
    final adoptionBloc = context.read<AdoptionBloc>();

    if (animalBloc.state.animals.isEmpty && !animalBloc.state.isLoading) {
      animalBloc.add(FetchAnimals());
    }
    if (adoptionBloc.state.animals.isEmpty && !adoptionBloc.state.isLoading) {
      adoptionBloc.add(FetchAdoptionAnimals());
    }
    await _loadMapsConfiguration();
    await _loadCurrentLocation();
  }

  Future<void> _loadMapsConfiguration() async {
    try {
      final config = await _mapsConfigChannel.invokeMapMethod<String, dynamic>(
        'getMapsConfiguration',
      );
      if (!mounted || config == null) return;

      final isConfigured = config['isConfigured'] == true;
      final packageName = config['packageName'] as String?;
      setState(() {
        _hasValidMapsApiKey = isConfigured;
        _mapsConfigurationHint = isConfigured
            ? null
            : 'Google Maps is not configured for ${packageName ?? 'this app'}. '
                  'Add MAPS_API_KEY to android/local.properties, then restart.';
      });
    } on MissingPluginException {
      // Keep the map enabled on platforms without the Android channel.
    } on PlatformException {
      if (!mounted) return;
      setState(() {
        _hasValidMapsApiKey = false;
        _mapsConfigurationHint =
            'Unable to verify Google Maps setup on Android right now.';
      });
    }
  }

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
      _animateTo(target);
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

  Future<void> _animateTo(LatLng target, {double zoom = 13.4}) async {
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
        accent: AppPalette.sunset,
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
        accent: AppPalette.magenta,
        animal: animal,
      );
    });
  }

  List<_MapPoint> _buildPeoplePoints() {
    final people = [
      _NearbyPerson(
        'person_1',
        'Mona Ali',
        'Adoption coordinator',
        'Same district',
        AppPalette.indigo,
        const Offset(0.003, -0.005),
      ),
      _NearbyPerson(
        'person_2',
        'Omar Hassan',
        'Pet transporter',
        '1.1 km away',
        const Color(0xFF755C95),
        const Offset(-0.004, 0.003),
      ),
      _NearbyPerson(
        'person_3',
        'Sara Nabil',
        'Local rescuer',
        'Same area',
        AppPalette.sunset,
        const Offset(0.007, 0.001),
      ),
      _NearbyPerson(
        'person_4',
        'Dr. Karim',
        'Vet support',
        '1.8 km away',
        AppPalette.plum,
        const Offset(-0.007, -0.007),
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
            position: _shift(
              _currentCenter,
              person.offset.dx,
              person.offset.dy,
            ),
            accent: person.accent,
            person: person,
          ),
        )
        .toList();
  }

  List<_MapPoint> _applyFilter(List<_MapPoint> points) {
    return switch (_activeFilter) {
      _MapFilter.sale =>
        points.where((point) => point.kind == _MapPointKind.sale).toList(),
      _MapFilter.adoption =>
        points.where((point) => point.kind == _MapPointKind.adoption).toList(),
      _MapFilter.people =>
        points.where((point) => point.kind == _MapPointKind.person).toList(),
      _MapFilter.all => points,
    };
  }

  double _markerHue(_MapPointKind kind) {
    return switch (kind) {
      _MapPointKind.sale => BitmapDescriptor.hueOrange,
      _MapPointKind.adoption => BitmapDescriptor.hueGreen,
      _MapPointKind.person => BitmapDescriptor.hueAzure,
    };
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
          infoWindow: InfoWindow(title: point.title, snippet: point.subtitle),
          icon: BitmapDescriptor.defaultMarkerWithHue(_markerHue(point.kind)),
          onTap: () => setState(() => _selectedPointId = point.id),
        ),
      );
    }
    return markers;
  }

  void _focusPoint(_MapPoint point) {
    setState(() => _selectedPointId = point.id);
    _animateTo(point.position, zoom: 14.6);
  }

  void _openPoint(_MapPoint point) {
    if (point.kind == _MapPointKind.person && point.person != null) {
      context.push(
        '/chat-detail',
        extra: {'userName': point.person!.name, 'userId': point.person!.id},
      );
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
      backgroundColor: AppPalette.shell,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      body: BlocBuilder<AnimalBloc, AnimalState>(
        builder: (context, animalState) {
          return BlocBuilder<AdoptionBloc, AdoptionState>(
            builder: (context, adoptionState) {
              final saleAnimals = animalState.animals;
              final adoptionAnimals = adoptionState.animals;
              final peoplePoints = _buildPeoplePoints();
              final visiblePoints = _applyFilter([
                ..._buildSalePoints(saleAnimals),
                ..._buildAdoptionPoints(adoptionAnimals),
                ...peoplePoints,
              ]);

              _MapPoint? selectedPoint;
              if (visiblePoints.isNotEmpty) {
                final selectedMatch = visiblePoints.where(
                  (point) => point.id == _selectedPointId,
                );
                selectedPoint = selectedMatch.isNotEmpty
                    ? selectedMatch.first
                    : visiblePoints.first;
              }

              return _MapLayout(
                currentCenter: _currentCenter,
                hasLocationPermission: _hasLocationPermission,
                hasValidMapsApiKey: _hasValidMapsApiKey,
                markers: _buildMarkers(visiblePoints),
                areaLabel: _areaLabel,
                isLoadingLocation: _isLoadingLocation,
                mapsConfigurationHint: _mapsConfigurationHint,
                saleCount: saleAnimals.length,
                adoptionCount: adoptionAnimals.length,
                peopleCount: peoplePoints.length,
                activeFilter: _activeFilter,
                onFilterChanged: (filter) =>
                    setState(() => _activeFilter = filter),
                onLocate: _loadCurrentLocation,
                onMapCreated: (controller) {
                  _mapController = controller;
                  _animateTo(_currentCenter, zoom: 12.4);
                },
                onMapTap: () => setState(() => _selectedPointId = null),
                isResultsPanelVisible: _isResultsPanelVisible,
                onTogglePanel: () {
                  setState(
                    () => _isResultsPanelVisible = !_isResultsPanelVisible,
                  );
                },
                points: visiblePoints,
                selectedPoint: selectedPoint,
                onFocusPoint: _focusPoint,
                onOpenPoint: _openPoint,
              );
            },
          );
        },
      ),
    );
  }
}

class _MapLayout extends StatelessWidget {
  const _MapLayout({
    required this.currentCenter,
    required this.hasLocationPermission,
    required this.hasValidMapsApiKey,
    required this.markers,
    required this.areaLabel,
    required this.isLoadingLocation,
    required this.mapsConfigurationHint,
    required this.saleCount,
    required this.adoptionCount,
    required this.peopleCount,
    required this.activeFilter,
    required this.onFilterChanged,
    required this.onLocate,
    required this.onMapCreated,
    required this.onMapTap,
    required this.isResultsPanelVisible,
    required this.onTogglePanel,
    required this.points,
    required this.selectedPoint,
    required this.onFocusPoint,
    required this.onOpenPoint,
  });

  final LatLng currentCenter;
  final bool hasLocationPermission;
  final bool hasValidMapsApiKey;
  final Set<Marker> markers;
  final String areaLabel;
  final bool isLoadingLocation;
  final String? mapsConfigurationHint;
  final int saleCount;
  final int adoptionCount;
  final int peopleCount;
  final _MapFilter activeFilter;
  final ValueChanged<_MapFilter> onFilterChanged;
  final VoidCallback onLocate;
  final ValueChanged<GoogleMapController> onMapCreated;
  final VoidCallback onMapTap;
  final bool isResultsPanelVisible;
  final VoidCallback onTogglePanel;
  final List<_MapPoint> points;
  final _MapPoint? selectedPoint;
  final ValueChanged<_MapPoint> onFocusPoint;
  final ValueChanged<_MapPoint> onOpenPoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final panelHeight = isResultsPanelVisible ? 270.0 : 58.0;
    final floatingButtonsBottom = isResultsPanelVisible ? 286.0 : 118.0;
    final filters = [
      (_MapFilter.all, 'All', Icons.grid_view_rounded),
      (_MapFilter.sale, 'Sale', Icons.sell_outlined),
      (_MapFilter.adoption, 'Adopt', Icons.favorite_border_rounded),
      (_MapFilter.people, 'People', Icons.group_outlined),
    ];

    return Stack(
      children: [
        if (hasValidMapsApiKey)
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentCenter,
              zoom: 12.4,
            ),
            myLocationEnabled: hasLocationPermission,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            onTap: (_) => onMapTap(),
            onMapCreated: onMapCreated,
            markers: markers,
          )
        else
          _MapUnavailableView(message: mapsConfigurationHint),
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPalette.shell.withOpacity(0.86),
                  AppPalette.shell.withOpacity(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.24],
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                _MapTopCard(
                  areaLabel: areaLabel,
                  isLoadingLocation: isLoadingLocation,
                  saleCount: saleCount,
                  adoptionCount: adoptionCount,
                  peopleCount: peopleCount,
                  onLocate: onLocate,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: scheme.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
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
                        onTap: () => onFilterChanged(filter),
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: isSelected
                                ? scheme.primary
                                : const Color(0xFFF3F4EF),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                icon,
                                size: 15,
                                color: isSelected
                                    ? Colors.white
                                    : scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                label,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        for (final data in [
          (Icons.my_location_rounded, floatingButtonsBottom + 52, onLocate),
          (Icons.layers_outlined, floatingButtonsBottom, onTogglePanel),
        ])
          AnimatedPositioned(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            right: 16,
            bottom: data.$2,
            child: _MapFloatingButton(icon: data.$1, onTap: data.$3),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            height: panelHeight,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 92),
            padding: EdgeInsets.fromLTRB(
              14,
              isResultsPanelVisible ? 12 : 10,
              14,
              isResultsPanelVisible ? 14 : 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: scheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: isResultsPanelVisible
                  ? _ExpandedPanel(
                      key: const ValueKey('expanded'),
                      points: points,
                      selectedPoint: selectedPoint,
                      onTogglePanel: onTogglePanel,
                      onFocusPoint: onFocusPoint,
                      onOpenPoint: onOpenPoint,
                    )
                  : _CollapsedPanel(
                      key: const ValueKey('collapsed'),
                      resultsCount: points.length,
                      onTogglePanel: onTogglePanel,
                    ),
            ),
          ),
        ),
      ],
    );
  }
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget stat(String value, String label) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withOpacity(0.78),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            Color.alphaBlend(
              scheme.secondary.withOpacity(0.28),
              scheme.primary,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withOpacity(0.22),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Live map',
                  style: theme.textTheme.labelMedium?.copyWith(
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: isLoadingLocation
                      ? const Padding(
                          padding: EdgeInsets.all(11),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.1,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.gps_fixed_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Nearby pets, adoptions, and trusted helpers in one polished view.',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              height: 1.22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            areaLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.84),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              stat('$saleCount', 'Sale'),
              const SizedBox(width: 10),
              stat('$adoptionCount', 'Adopt'),
              const SizedBox(width: 10),
              stat('$peopleCount', 'Helpers'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapUnavailableView extends StatelessWidget {
  const _MapUnavailableView({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppPalette.blush, Color(0xFFF8EFE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.94),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: scheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: scheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.map_outlined,
                      color: scheme.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Map unavailable',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message ??
                        'Google Maps is not configured for this Android build yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7EEF4),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'Add MAPS_API_KEY to android/local.properties and enable Maps SDK for Android in Google Cloud.',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandedPanel extends StatelessWidget {
  const _ExpandedPanel({
    super.key,
    required this.points,
    required this.selectedPoint,
    required this.onTogglePanel,
    required this.onFocusPoint,
    required this.onOpenPoint,
  });

  final List<_MapPoint> points;
  final _MapPoint? selectedPoint;
  final VoidCallback onTogglePanel;
  final ValueChanged<_MapPoint> onFocusPoint;
  final ValueChanged<_MapPoint> onOpenPoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: GestureDetector(
            onTap: onTogglePanel,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                'Nearby results',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${points.length} found',
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          selectedPoint == null
              ? 'Animals, adopters, and trusted community members close to this area.'
              : 'Focused on ${selectedPoint!.title}. Tap the action button to continue.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: points.isEmpty
              ? Center(
                  child: Text(
                    'No nearby points in this filter yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: points.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final point = points[index];
                    final isSelected = point.id == selectedPoint?.id;
                    return GestureDetector(
                      onTap: () => onFocusPoint(point),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 192,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? point.accent.withOpacity(0.08)
                              : const Color(0xFFFCFCFA),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected
                                ? point.accent.withOpacity(0.38)
                                : const Color(0xFFE4E8E3),
                            width: isSelected ? 1.4 : 1,
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final compact = constraints.maxHeight < 130;
                            final spacing = compact ? 6.0 : 8.0;

                            return Column(
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
                                      child: Icon(
                                        point.icon,
                                        color: point.accent,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            point.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            point.distanceLabel,
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color:
                                                      scheme.onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: spacing),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: compact ? 3 : 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: point.accent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    point.badgeLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: point.accent,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (!compact) ...[
                                  SizedBox(height: spacing),
                                  Expanded(
                                    child: Text(
                                      point.subtitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                            height: 1.45,
                                          ),
                                    ),
                                  ),
                                ] else
                                  const Spacer(),
                                SizedBox(height: spacing),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => onOpenPoint(point),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: point.accent,
                                      minimumSize: Size.fromHeight(
                                        compact ? 30 : 34,
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.symmetric(
                                        vertical: compact ? 6 : 8,
                                      ),
                                      visualDensity: compact
                                          ? VisualDensity.compact
                                          : VisualDensity.standard,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      point.actionLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CollapsedPanel extends StatelessWidget {
  const _CollapsedPanel({
    super.key,
    required this.resultsCount,
    required this.onTogglePanel,
  });

  final int resultsCount;
  final VoidCallback onTogglePanel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTogglePanel,
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: scheme.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$resultsCount nearby points hidden',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              'Show',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFloatingButton extends StatelessWidget {
  const _MapFloatingButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: scheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, color: scheme.primary, size: 20),
        ),
      ),
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

  String get actionLabel => switch (kind) {
    _MapPointKind.sale => 'View animal',
    _MapPointKind.adoption => 'Open adoption',
    _MapPointKind.person => 'Start chat',
  };

  String get badgeLabel => switch (kind) {
    _MapPointKind.sale => 'For sale',
    _MapPointKind.adoption => 'Adoption',
    _MapPointKind.person => 'Nearby helper',
  };

  IconData get icon => switch (kind) {
    _MapPointKind.sale => Icons.sell_outlined,
    _MapPointKind.adoption => Icons.favorite_border_rounded,
    _MapPointKind.person => Icons.person_pin_circle_outlined,
  };
}

class _NearbyPerson {
  const _NearbyPerson(
    this.id,
    this.name,
    this.role,
    this.area,
    this.accent,
    this.offset,
  );

  final String id;
  final String name;
  final String role;
  final String area;
  final Color accent;
  final Offset offset;
}
