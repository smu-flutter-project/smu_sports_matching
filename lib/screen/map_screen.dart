import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  // 자동으로 그 위치 띄우기
  final LatLng _center = const LatLng(36.832639013904, 127.17668625829);
  final List<Marker> _markers = [];
  String? selectedTitle;
  String? selectedContext;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    _shareLocation();
  }

  // 장소 마커
  void _initializeMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('place1'),
        position: const LatLng(36.83231412298072, 127.1802609270142),
        infoWindow: const InfoWindow(
          title: "상명스포츠센터",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        // Red marker
        onTap: () => _onMarkerTapped("상명스포츠센터", "수영장, 스쿼시장, 헬스장, 무용실, 골프장"),
      ),
      Marker(
        markerId: const MarkerId('place2'),
        position: const LatLng(36.832553789241395, 127.17968417780898),
        infoWindow: const InfoWindow(
          title: "운동장",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        // Red marker
        onTap: () => _onMarkerTapped("운동장", "운동장이에유"),
      ),
      Marker(
        markerId: const MarkerId('place3'),
        position: const LatLng(36.8320360525678, 127.17941953531056),
        infoWindow: const InfoWindow(
          title: "농구장",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        // Red marker
        onTap: () => _onMarkerTapped("농구장", "실외 농구장이어유"),
      ),
      Marker(
        markerId: const MarkerId('place4'),
        position: const LatLng(36.83248755837282, 127.17878722906448),
        infoWindow: const InfoWindow(
          title: "체육관",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        // Red marker
        onTap: () => _onMarkerTapped("체육관", "실내 다양해유"),
      ),
    ]);
  }

  // 장소 마커 선택 함수
  void _onMarkerTapped(String title, String context) {
    setState(() {
      selectedTitle = title;
      selectedContext = context;
    });
  }

  // 위치 공유
  Future<void> _shareLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    // 파이어베이스 업로드
    Geolocator.getPositionStream().listen((Position position) {
      FirebaseFirestore.instance
          .collection('locations')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
        'isUser': true,
      });

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: FirebaseAuth.instance.currentUser?.displayName ?? 'Me',
            ),
          ),
        );
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    FirebaseFirestore.instance
        .collection('locations')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final userId = doc.id;
        final LatLng userPosition = LatLng(data['latitude'], data['longitude']);

        BitmapDescriptor markerColor = (data['isUser'] == true)
            ? BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen)
            : BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue);

        setState(() {
          _markers.removeWhere((marker) => marker.markerId.value == userId);
          _markers.add(
            Marker(
              markerId: MarkerId(userId),
              position: userPosition,
              icon: markerColor,
              infoWindow: InfoWindow(title: data['name']),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위치'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacementNamed(context, "/auth");
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 17.0,
            ),
            markers: Set<Marker>.of(_markers),
          ),
          if (selectedTitle != null && selectedContext != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedTitle!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 장소 마커 선택시
                    if (selectedContext != null && selectedTitle != null)
                      Column(
                        children: [
                          Text(
                            selectedContext!,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedTitle!,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTitle = null;
                              selectedContext = null;
                            });
                          },
                          child: const Text('종료'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
