import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  String _selectedFilter = 'All';
  
  final List<String> _filterOptions = [
    'All',
    'Hotels',
    'Restaurants',
    'Attractions',
    'Events',
  ];

  final List<Map<String, dynamic>> _places = [
    {
      'id': '1',
      'name': 'Grand Hotel',
      'category': 'Hotels',
      'rating': 4.5,
      'position': const LatLng(-7.250445, 110.400845),
    },
    {
      'id': '2',
      'name': 'Local Restaurant',
      'category': 'Restaurants',
      'rating': 4.8,
      'position': const LatLng(-7.251445, 110.401845),
    },
    {
      'id': '3',
      'name': 'Temple Complex',
      'category': 'Attractions',
      'rating': 4.9,
      'position': const LatLng(-7.252445, 110.402845),
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMarkers();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied'),
        ),
      );
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(title: 'You are here'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ),
    );
  }

  void _loadMarkers() {
    for (var place in _places) {
      if (_selectedFilter == 'All' || place['category'] == _selectedFilter) {
        _markers.add(
          Marker(
            markerId: MarkerId(place['id']),
            position: place['position'],
            infoWindow: InfoWindow(
              title: place['name'],
              snippet: '${place['category']} • ⭐ ${place['rating']}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _getMarkerColor(place['category']),
            ),
          ),
        );
      }
    }
    setState(() {});
  }

  double _getMarkerColor(String category) {
    switch (category) {
      case 'Hotels':
        return BitmapDescriptor.hueViolet;
      case 'Restaurants':
        return BitmapDescriptor.hueOrange;
      case 'Attractions':
        return BitmapDescriptor.hueGreen;
      case 'Events':
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(-7.250445, 110.400845), // Default position
              zoom: 14.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
          ),
          
          // Top controls
          SafeArea(
            child: Column(
              children: [
                // Search bar
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search places...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey[500]),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.filter_list, color: Colors.grey[600]),
                        onPressed: () {
                          _showFilterBottomSheet();
                        },
                      ),
                    ),
                  ),
                ),
                
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: _filterOptions.map((filter) {
                      bool isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                              _markers.clear();
                              _loadMarkers();
                            });
                          },
                          selectedColor: const Color(0xFF8CB369),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Current location button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Color(0xFF8CB369)),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ),
          
          // Bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_outlined, 'Home'),
                  _buildNavItem(Icons.map, 'Map', isSelected: true),
                  _buildNavItem(Icons.bookmark_outline, 'Saved'),
                  _buildNavItem(Icons.person_outline, 'Profile'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF8CB369) : Colors.grey[400],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? const Color(0xFF8CB369) : Colors.grey[400],
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Places',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: _filterOptions.map((filter) {
                  return ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                        _markers.clear();
                        _loadMarkers();
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}