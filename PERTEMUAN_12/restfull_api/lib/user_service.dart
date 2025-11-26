import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart'; // Asumsikan kelas User.dart sudah ada di folder lib/

class UserService {
  // Base URL API (menggunakan JSONPlaceholder sebagai contoh)
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String _userKey = 'cached_user_data';

  // =================================================================
  // API INTERACTION (POST Request Example)
  // =================================================================
  Future<User?> createUser(String name, String email) async {
    final url = Uri.parse('$_baseUrl/users');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          // Mengirim data minimum ke server
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        // Status 201 Created (Sukses)
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        
        // JSONPlaceholder tidak mengembalikan field 'created_at',
        // jadi kita tambahkan secara manual untuk memenuhi Model User kita.
        jsonResponse['created_at'] = DateTime.now().toIso8601String(); 

        final newUser = User.fromJson(jsonResponse);
        await saveUserLocally(newUser); // Simpan data ke SharedPreferences
        return newUser;
      } else {
        print('Failed to create user. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network error: $e');
      return null;
    }
  }
  
  // =================================================================
  // LOCAL STORAGE (Shared Preferences)
  // =================================================================
  
  // Menyimpan objek User ke SharedPreferences
  Future<void> saveUserLocally(User user) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Konversi objek User ke JSON String menggunakan toJson()
    final userJson = jsonEncode(user.toJson()); 
    await prefs.setString(_userKey, userJson);
    print('User saved locally: ${user.name}');
  }

  // Mengambil objek User dari SharedPreferences
  Future<User?> getLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString(_userKey);

    if (userJsonString != null) {
      // Konversi JSON String kembali ke objek User menggunakan fromJson()
      final Map<String, dynamic> jsonMap = jsonDecode(userJsonString);
      return User.fromJson(jsonMap);
    }
    return null;
  }
  
  // Menghapus data User lokal
  Future<void> clearLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    print('Local user data cleared.');
  }
}