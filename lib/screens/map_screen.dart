import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:dawak/controller.dart';

class Pharmacy {
  final String name;
  final LatLng location;

  Pharmacy({required this.name, required this.location});
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;
  String? userLocationName;
  final Controller appController = Get.find();
  List<Pharmacy> allPharmacies = [
    Pharmacy(name: "صيدلية الشفاء", location: LatLng(25.276987, 51.520008)),
    Pharmacy(name: "صيدلية الحياة", location: LatLng(25.280000, 51.525000)),
    Pharmacy(name: "صيدلية الدوحة", location: LatLng(25.290000, 51.530000)),
    Pharmacy(name: "صيدلية الندى", location: LatLng(25.300000, 51.535000)),
  ];

  List<Pharmacy> nearbyPharmacies = [];

  @override
  void initState() {
    super.initState();
    _initLocationAndName();
  }

  Future<void> _initLocationAndName() async {
    await getCurrentLocation();
    if (userLocation != null) {
      await fetchUserLocationName();
      filterNearbyPharmacies();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("يرجى تفعيل GPS من الإعدادات.")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم رفض صلاحية الموقع.")),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      appController.showErrorMsg('حدث خطأ', "خطأ أثناء الحصول على الموقع: $e");
    }
  }

  Future<void> fetchUserLocationName() async {
    if (userLocation == null) return;

    final lat = userLocation!.latitude;
    final lon = userLocation!.longitude;

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon&accept-language=ar');

    final response = await http.get(url, headers: {
      'User-Agent': 'FlutterApp', // مطلوب من OpenStreetMap
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        userLocationName = data['display_name'] ?? "موقعي الحالي";
      });
    } else {
      appController.showErrorMsg('حدث خطأ', 'فشل في جلب اسم الموقع: ${response.statusCode}');
    }
  }

  void filterNearbyPharmacies() {
    if (userLocation == null) return;

    final Distance distance = Distance();

    final nearby = allPharmacies.where((pharmacy) {
      final km = distance.as(LengthUnit.Kilometer, userLocation!, pharmacy.location);
      return km <= 1.0;
    }).toList();

    setState(() {
      nearbyPharmacies = nearby;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return  Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 32, 119, 90),
        foregroundColor: Colors.white,
        title: Text("الصيدليات القريبة مني", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),),
      centerTitle: true,),
      body: (appController.isConnected.value) ? FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.bounds(
            bounds: LatLngBounds(
              LatLng(userLocation!.latitude - 0.0005, userLocation!.longitude - 0.0005),
              LatLng(userLocation!.latitude + 0.0005, userLocation!.longitude + 0.0005),
            ),
            padding: const EdgeInsets.all(100),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.dawak',
          ),
          MarkerLayer(
            markers: [
              // موقع المستخدم
              Marker(
                point: userLocation!,
                width: 150,
                height: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (userLocationName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3)],
                        ),
                        child: FittedBox(
                          child: Text(
                            userLocationName!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    const Icon(Icons.my_location, color: Colors.red, size: 40),
                  ],
                ),
              ),

              // الصيدليات القريبة
              ...nearbyPharmacies.map(
                (pharmacy) => Marker(
                  point: pharmacy.location,
                  width: 130,
                  height: 90,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3)],
                        ),
                        child: FittedBox(
                          child: Text(
                            pharmacy.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Icon(Icons.local_pharmacy, color: Colors.blue, size: 35),
                    ]  ),
                )  ),
            ],  ),
        ],
      ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'images/no_internet.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      
                        'لا يوجد إتصال بالإنترنت',
                        
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    )  )
                ]  )
    );
  }
}