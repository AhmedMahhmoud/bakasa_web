import 'dart:convert';

import 'package:bakasa_web/config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// Resolves coordinates to a human-readable place name (no raw lat/lng in UI).
///
/// - **Web:** [BigDataCloud](https://www.bigdatacloud.com/docs/api/reverse-geocode-client)
///   client API (CORS-friendly).
/// - **Other platforms:** OpenStreetMap Nominatim ([usage policy](https://operations.osmfoundation.org/policies/nominatim/)).
class ReverseGeocodeService {
  ReverseGeocodeService._();

  static String _languageCode(String localeTag) {
    final t = localeTag.trim();
    if (t.isEmpty) return 'en';
    final dash = t.indexOf('-');
    return dash > 0 ? t.substring(0, dash) : t;
  }

  static Future<String?> addressFromCoordinates({
    required double latitude,
    required double longitude,
    String acceptLanguage = 'en',
  }) async {
    final lang = _languageCode(acceptLanguage);
    if (kIsWeb) {
      return _bigDataCloud(latitude, longitude, lang);
    }
    return _nominatim(latitude, longitude, lang);
  }

  static Future<String?> _bigDataCloud(
    double latitude,
    double longitude,
    String localityLanguage,
  ) async {
    final uri = Uri.https('api.bigdatacloud.net', '/data/reverse-geocode-client', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'localityLanguage': localityLanguage,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    try {
      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return null;

      final locality = (data['locality'] as String?)?.trim();
      final city = (data['city'] as String?)?.trim();
      final region = (data['principalSubdivision'] as String?)?.trim();
      final country = (data['countryName'] as String?)?.trim();

      final parts = <String>[];
      if (locality != null && locality.isNotEmpty) parts.add(locality);
      if (city != null && city.isNotEmpty && city != locality) parts.add(city);
      if (region != null && region.isNotEmpty) parts.add(region);
      if (country != null && country.isNotEmpty) parts.add(country);

      if (parts.isEmpty) return null;
      return parts.join(', ');
    } on FormatException {
      return null;
    }
  }

  static Future<String?> _nominatim(
    double latitude,
    double longitude,
    String acceptLanguage,
  ) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'format': 'jsonv2',
      'lat': latitude.toString(),
      'lon': longitude.toString(),
    });

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': BakasaConfig.nominatimUserAgent,
        'Accept-Language': acceptLanguage,
      },
    );

    if (response.statusCode != 200) return null;

    try {
      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return null;
      final name = data['display_name'];
      if (name is String && name.trim().isNotEmpty) {
        return name.trim();
      }
      return null;
    } on FormatException {
      return null;
    }
  }
}
