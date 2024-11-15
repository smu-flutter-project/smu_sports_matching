import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  String? selectedTitle; // title 변수
  String? selectedSnippet; // 장소 설명 변수
  String? indoorOutdoor; // 실내외 변수

  String? selectedDate; // 날짜 변수
  String? selectedSport; // 스포츠 변수

  // 지도 첫 화면 기준이 상명대 정문을 나타냄.
  final LatLng _center = const LatLng(36.832639013904, 127.17668625829);

  // marker들을 list로 표현
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('place'),
        position: const LatLng(36.83231412298072, 127.1802609270142),
        infoWindow: const InfoWindow(
          title: "상명스포츠센터",
        ),
        onTap: () => _onMarkerTapped("상명스포츠센터", "수영장, 스쿼시장, 헬스장, 무용실, 골프장", "실내"),
      ),
      Marker(
        markerId: const MarkerId('place'),
        position: const LatLng(36.832553789241395, 127.17968417780898),
        infoWindow: const InfoWindow(
          title: "운동장",
        ),
        onTap: () => _onMarkerTapped("운동장", "운동장이에유", "실외"),
      ),
      Marker(
        markerId: const MarkerId('place'),
        position: const LatLng(36.8320360525678, 127.17941953531056),
        infoWindow: const InfoWindow(
          title: "농구장",
        ),
        onTap: () => _onMarkerTapped("농구장", "실외 농구장이어유", "실외"),
      ),
      Marker(
        markerId: const MarkerId('place'),
        position: const LatLng(36.83248755837282, 127.17878722906448),
        infoWindow: const InfoWindow(
          title: "체육관",
        ),
        onTap: () => _onMarkerTapped("체육관", "실내 다양해유", "실내"),
      ),

      // 사람 마커에 대한 내용
      Marker(
        markerId: const MarkerId('human1'),
        position: const LatLng(36.832139439004465, 127.17639102013793),
        infoWindow: const InfoWindow(
          title: "김준하",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () => _onPersonMarkerTapped("김준하", "11월 11일", "축구"),
      ),
      Marker(
        markerId: const MarkerId('human2'),
        position: const LatLng(36.83406247764723, 127.1792471408844),
        infoWindow: const InfoWindow(
          title: "김 연",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () => _onPersonMarkerTapped("김 연", "11월 12일", "농구"),
      ),
      Marker(
        markerId: const MarkerId('human3'),
        position: const LatLng(36.83135749542505, 127.17907011508942),
        infoWindow: const InfoWindow(
          title: "김민욱",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () => _onPersonMarkerTapped("김민욱", "11월 13일", "스쿼시"),
      ),
      Marker(
        markerId: const MarkerId('human4'),
        position: const LatLng(36.83262841961985, 127.181156873703),
        infoWindow: const InfoWindow(
          title: "현용찬",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () => _onPersonMarkerTapped("현용찬", "11월 21일", "농구"),
      ),
    ]);
  }

  // 장소 마커 선택
  void _onMarkerTapped(String title, String snippet, String locationType) {
    setState(() {
      selectedTitle = title;
      selectedSnippet = snippet;
      indoorOutdoor = locationType;
      selectedDate = null;
      selectedSport = null;
    });
  }

  // 사람 마커 선택
  void _onPersonMarkerTapped(String title, String date, String sport) {
    setState(() {
      selectedTitle = title;
      selectedDate = date;
      selectedSport = sport;
      indoorOutdoor = null;
      selectedSnippet = null;
    });
  }

  // google map
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar 제작
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

          // title 값이 없을 경우, 하단에 아무것도 띄우지않음(full map)
          if (selectedTitle != null)
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

                    //사람 마커 선택시
                    if (selectedSnippet != null)
                      Text(
                        selectedSnippet!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),

                    // 장소 마커 선택시
                    if (selectedDate != null && selectedSport != null)
                      Column(
                        children: [
                          Text(
                            selectedDate!,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedSport!,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
                              selectedSnippet = null;
                              indoorOutdoor = null;
                              selectedDate = null;
                              selectedSport = null;
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
