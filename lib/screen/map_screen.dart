import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  String? selectedTitle;
  String? selectedSnippet;
  String? indoorOutdoor;

  final LatLng _center = const LatLng(36.832639013904, 127.17668625829);

  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('상명스포츠센터'),
        position: const LatLng(36.83231412298072, 127.1802609270142),
        infoWindow: const InfoWindow(
          title: "상명스포츠센터",
        ),
        onTap: () => _onMarkerTapped("상명스포츠센터", "수영장, 스쿼시장, 헬스장, 무용실, 골프장", "실내"),
      ),
      Marker(
        markerId: const MarkerId('운동장'),
        position: const LatLng(36.832553789241395, 127.17968417780898),
        infoWindow: const InfoWindow(
          title: "운동장",
        ),
        onTap: () => _onMarkerTapped("운동장", "운동장이에유", "실외"),
      ),
      Marker(
        markerId: const MarkerId('농구장'),
        position: const LatLng(36.8320360525678, 127.17941953531056),
        infoWindow: const InfoWindow(
          title: "농구장",
        ),
        onTap: () => _onMarkerTapped("농구장", "실외 농구장이어유", "실외"),
      ),
      Marker(
        markerId: const MarkerId('체육관'),
        position: const LatLng(36.83248755837282, 127.17878722906448),
        infoWindow: const InfoWindow(
          title: "체육관",
        ),
        onTap: () => _onMarkerTapped("체육관", "실내 다양해유", "실내"),
      ),
    ]);
  }

  void _onMarkerTapped(String title, String snippet, String locationType) {
    setState(() {
      selectedTitle = title;
      selectedSnippet = snippet;
      indoorOutdoor = locationType;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상명대학교'),
        backgroundColor: Colors.blue[500],
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
          if (selectedTitle != null && selectedSnippet != null)
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
                    Text(
                      selectedSnippet!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(indoorOutdoor ?? '실내/실외'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedTitle = null;
                              selectedSnippet = null;
                              indoorOutdoor = null;
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
