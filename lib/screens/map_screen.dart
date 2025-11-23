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
  // Using a default position (Semarang) to avoid null errors if permissions aren't granted immediately
  final LatLng _defaultPos = const LatLng(-6.966667, 110.416664); 
  final Set<Marker> _markers = {};
  
  @override
  Widget build(BuildContext context) {
    // Use a Container or simple Widget, do NOT use Scaffold here to avoid double scaffolding
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) => _mapController = controller,
          initialCameraPosition: CameraPosition(target: _defaultPos, zoom: 12.0),
          markers: _markers,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
        ),
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search places on map...',
                border: InputBorder.none,
                icon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {}, // Add filter logic
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}