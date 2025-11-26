// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import '../config/api_config.dart'; // Import konfigurasi

class ApiService {
  Future<http.Response> getUsers() async {
    // Menggunakan baseURL dan usersEndpoint dari ApiConfig
    final uri = Uri.parse(ApiConfig.baseURL + ApiConfig.usersEndpoint);
    
    // Menggunakan headers dari ApiConfig
    final response = await http.get(uri, headers: ApiConfig.headers);
    
    return response;
  }
}