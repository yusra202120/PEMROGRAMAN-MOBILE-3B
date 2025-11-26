import 'package:flutter/material.dart'; // Diperlukan jika dijalankan sebagai Flutter app, atau bisa diabaikan jika hanya menggunakan Dart
import 'user.dart'; // Sesuaikan dengan lokasi file user.dart Anda

void main() {
  print('=== DEBUG: Check JSON Structure ===');

  // ------------------------------------------------
  // 1. Object Dart ke JSON (Menggunakan toJson())
  // ------------------------------------------------
  User user = User(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    createdAt: DateTime.now(),
  ); // User

  Map<String, dynamic> userJson = user.toJson();
  
  print('User.toJson() result: $userJson');
  print('Field names: ${userJson.keys.toList()}'); // Menampilkan kunci-kunci Map yang dihasilkan

  print('\n=== TEST: JSON to Object ===');

  // ------------------------------------------------
  // 2. JSON ke Object Dart (Menggunakan fromJson())
  // ------------------------------------------------
  // ✔ GUNAKAN FIELD NAMES YANG SAMA DENGAN toJson() RESULT
  Map<String, dynamic> jsonData = {
    'id': 2,
    'name': 'Jane Doe',
    'email': 'jane@example.com',
    'created_at': '2024-01-01T10:00:00.000Z', // Perhatikan casing: 'created_at'
  };

  // Debug: Print JSON structure sebelum di-parse
  print('JSON data to parse: $jsonData');
  print('JSON keys: ${jsonData.keys.toList()}');
  print('id: ${jsonData['id']} (type: ${jsonData['id'].runtimeType})');
  print('name: ${jsonData['name']} (type: ${jsonData['name'].runtimeType})');
  print('created_at: ${jsonData['created_at']} (type: ${jsonData['created_at'].runtimeType})');
  print('');

  // ------------------------------------------------
  // 3. Pengujian Parsing dan Error Handling
  // ------------------------------------------------
  
  // A. Konversi Data Lengkap dan Tangani Error
  try {
    print('Testing fromJson with complete data...');
    User userFromJson = User.fromJson(jsonData); 
    print('✅ SUCCESS: User from JSON: $userFromJson'); // Memanggil method toString()
  } catch (e, stack) {
    print('❌ ERROR: $e');
    print('Stack trace: $stack');
  }

  print('\n=== TEST: Handle Missing Fields (Nullable fields should pass) ===');

  // B. Test dengan missing fields
  Map<String, dynamic> incompleteJson = {
    'id': 3,
    // 'name': missing
    'email': 'test@example.com',
    // 'created_at': missing
  };

  try {
    // Karena semua field di User sekarang nullable (final int? id, dll),
    // ini seharusnya TIDAK melempar error, melainkan mengisi field yang hilang dengan null.
    User userFromIncomplete = User.fromJson(incompleteJson);
    print('User from incomplete JSON: $userFromIncomplete');
    
    // Uji validasi yang kita buat:
    // User dianggap TIDAK valid karena 'name' adalah null/kosong
    print('Is userFromIncomplete valid? ${userFromIncomplete.isValid ? 'YES' : 'NO'}'); 

  } catch (e) {
    // Blok catch ini hanya akan dieksekusi jika terjadi error parsing fatal
    print('Error with incomplete JSON: $e');
  }
} 