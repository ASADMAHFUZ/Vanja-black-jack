/// Put your Google Maps API key here for Android / iOS / Maps JS.
/// Web preview also works via Google Maps embed without a key.
class MapsConfig {
  static const apiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static bool get hasApiKey => apiKey.trim().isNotEmpty;
}
