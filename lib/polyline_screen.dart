import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineScreen extends StatefulWidget {
  const PolylineScreen({super.key});

  @override
  State<PolylineScreen> createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  GoogleMapController? _mapController;

  LatLng? _currentLocation;

  final LatLng _destination =
  const LatLng(30.520, 72.358);

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _currentLocation = LatLng(position.latitude, position.longitude);

    _addMarkers();
    _addPolyline();

    setState(() {});
  }

  void _addMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId("source"),
        position: _currentLocation!,
        infoWindow: const InfoWindow(title: "Current Location"),
      ),
      Marker(
        markerId: const MarkerId("destination"),
        position: _destination,
        infoWindow: const InfoWindow(title: "Destination"),
      ),
      Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(30.520, 56.358),
        infoWindow: const InfoWindow(title: "Destination"),
      ),
    };
  }

  void _addPolyline() {
    _polylines = {
      Polyline(
        polylineId: const PolylineId("route"),
        points: [
          _currentLocation!,
          _destination,
          LatLng(30.520, 56.358)
        ],
        color: Colors.blue,
        width: 5,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Polyline Route")),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 13,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
      ),
    );
  }
}
