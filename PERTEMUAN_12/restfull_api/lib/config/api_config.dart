// lib/config/api_config.dart

class ApiConfig {
  // Ganti URL ini dengan alamat WireMock Cloud Anda
  static const String baseURL = 'https://izvymq.wiremockapi.cloud';
  
  static const String usersEndpoint = '/users';
  static const int timeoutSeconds = 30;

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}