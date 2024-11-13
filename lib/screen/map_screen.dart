import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(36.832639013904, 127.17668625829);

  final List<Marker> _markers = [ // 지도 위 마커들을 표시함
    const Marker(
      markerId: MarkerId('상명스포츠센터'),
      position: LatLng(36.83231412298072, 127.1802609270142),
      infoWindow: InfoWindow(
        title: "상명스포츠센터",
        snippet: "수영장, 스쿼시장, 헬스장, 무용실, 골프장",
      ),
    ),
    const Marker(
      markerId: MarkerId('운동장'),
      position: LatLng(36.832553789241395, 127.17968417780898),
      infoWindow: InfoWindow(
        title: "운동장",
        snippet: "운동장이에유",
      ),
    ),
    const Marker(
      markerId: MarkerId('농구장'),
      position: LatLng(36.8320360525678, 127.17941953531056),
      infoWindow: InfoWindow(
        title: "농구장",
        snippet: "실외 농구장이어유",
      ),
    ),
    const Marker(
      markerId: MarkerId('체육관'),
      position: LatLng(36.83248755837282, 127.17878722906448),
      infoWindow: InfoWindow(
        title: "체육관",
        snippet: "실내 다양해유",
      ),
    ),
  ];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: const Text('SMU'), backgroundColor: Colors.blue[500]),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
          markers: Set<Marker>.of(_markers), // 여러 개의 마커를 표시
        ),
      ),
    );
  }
}