import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

class OpenStreetLocationPage extends StatefulWidget {
  const OpenStreetLocationPage({super.key});

  @override
  State<OpenStreetLocationPage> createState() => _OpenStreetLocationPageState();
}

class _OpenStreetLocationPageState extends State<OpenStreetLocationPage> {
  final pickupController = TextEditingController();
  final dropController = TextEditingController();

  LatLng mapCenter = LatLng(17.3850, 78.4867);
  List<Marker> markers = [];

  void searchLocation(String query, bool isPickup) async {
    final geo = await NominatimGeocoding.to.forwardGeoCoding(query as Address);
    if (geo != null) {
      final lat = geo.coordinate.latitude.toDouble();
      final lon = geo.coordinate.longitude.toDouble();

      setState(() {
        mapCenter = LatLng(lat, lon);

        final marker = Marker(
          point: mapCenter,
          width: 60,
          height: 60,
          child: Icon(
            isPickup ? Icons.location_on : Icons.flag,
            size: 40,
            color: isPickup ? Colors.green : Colors.blue,
          ),
        );

        markers.removeWhere((m) =>
          m.child is Icon &&
          (isPickup
              ? (m.child as Icon).color == Colors.green
              : (m.child as Icon).color == Colors.blue)
        );
        markers.add(marker);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    NominatimGeocoding.init(reqCacheNum: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text("Select Pickup & Drop"),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: pickupController,
                        onSubmitted: (v) => searchLocation(v, true),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter pickup location',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () => searchLocation(pickupController.text, true),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: dropController,
                        onSubmitted: (v) => searchLocation(v, false),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter drop location',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () => searchLocation(dropController.text, false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(center: mapCenter, zoom: 14.0),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
