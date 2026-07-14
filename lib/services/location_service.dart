import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String address;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class LocationService {
  static Future<LocationResult?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final geocoding = Geocoding();
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = _formatAddress(placemarks.firstOrNull);
      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (_) {
      return null;
    }
  }

  static String _formatAddress(Placemark? p) {
    if (p == null) return 'Unknown location';
    final parts = [
      if (p.street != null && p.street!.isNotEmpty) p.street,
      if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
      if (p.locality != null && p.locality!.isNotEmpty) p.locality,
      if (p.country != null && p.country!.isNotEmpty) p.country,
    ];
    return parts.isNotEmpty ? parts.join(', ') : 'Unknown location';
  }
}
