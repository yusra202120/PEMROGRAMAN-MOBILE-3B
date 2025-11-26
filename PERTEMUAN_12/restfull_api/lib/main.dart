import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Digunakan untuk DateFormat

// --- 1. PreferenceService (Singleton) ---
// Kelas ini mengelola operasi I/O untuk SharedPreferences.

class PreferenceService {
  static final PreferenceService _instance = PreferenceService._internal();

  // Factory constructor untuk mengembalikan instance yang sama (Singleton)
  factory PreferenceService() => _instance;

  // Private named constructor
  PreferenceService._internal();

  late SharedPreferences _prefs;

  // Inisialisasi SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Metode untuk menyimpan data
  Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);
  Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  // Metode untuk memuat data
  String? getString(String key) => _prefs.getString(key);
  int? getInt(String key) => _prefs.getInt(key);

  // Metode untuk menghapus data (contohnya remove dan clear, dari potongan kode Anda)
  Future<bool> remove(String key) async => await _prefs.remove(key);
  Future<bool> clear() async => await _prefs.clear();
}

// --- 2. Fungsi main() dan MyApp ---

void main() async {
  // Memastikan Flutter Widgets terikat sebelum memanggil init()
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menginisialisasi PreferenceService
  final prefs = PreferenceService();
  await prefs.init();

  // Menjalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(), 
    ); 
  }
}

// --- 3. ProfilePage (StatefulWidget) ---

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// --- 4. _ProfilePageState (State dan Logika) ---

class _ProfilePageState extends State<ProfilePage> {
  // Menggunakan instance PreferenceService yang sudah diinisialisasi di main
  final PreferenceService _prefs = PreferenceService(); 

  // Controller untuk input field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Variabel state untuk menampilkan data yang tersimpan
  String? _savedName = '';
  String? _savedEmail = '';
  String? _lastUpdated = '';

  @override
  void initState() {
    super.initState();
    // Memuat data saat widget pertama kali dibuat
    _loadUserData(); 
  }

  // Metode untuk memuat data dari SharedPreferences
  Future<void> _loadUserData() async {
    String? name = _prefs.getString('user_name');
    String? email = _prefs.getString('user_email');
    int? lastUpdateMillis = _prefs.getInt('last_update');

    setState(() {
      // Mengisi controller
      _nameController.text = name ?? '';
      _emailController.text = email ?? '';
      
      // Menyimpan data yang tersimpan untuk ditampilkan
      _savedName = name;
      _savedEmail = email;

      if (lastUpdateMillis != null) {
        // Mengkonversi milidetik epoch ke objek DateTime
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(lastUpdateMillis);
        // Menggunakan DateFormat untuk memformat tanggal
        _lastUpdated = DateFormat('dd MMM yyyy, HH:mm').format(dt);
      } else {
        _lastUpdated = null; // Menetapkan ke null agar ditampilkan sebagai '-'
      }
    });
  }

  // Metode untuk menyimpan data ke SharedPreferences
  Future<void> _saveUserData() async {
    // Menyimpan nilai dari controller
    await _prefs.setString('user_name', _nameController.text);
    await _prefs.setString('user_email', _emailController.text);
    // Menyimpan waktu saat ini dalam milidetik sejak epoch
    await _prefs.setInt('last_update', DateTime.now().millisecondsSinceEpoch);

    // Memuat ulang data untuk memperbarui tampilan
    await _loadUserData();

    // Menampilkan Snackbar notifikasi
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    }
  }

  // Metode build sesuai dengan potongan kode UI terakhir yang Anda berikan
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Input form
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData, 
              child: const Text('Save')
            ),
            const Divider(height: 40),

            // Data yang disimpan
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Data Tersimpan:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Menggunakan operator ?? '-' untuk menampilkan '-' jika null
                  Text('Nama: ${_savedName ?? '-'}'), 
                  Text('Email: ${_savedEmail ?? '-'}'),
                  Text('Terakhir diperbarui: ${_lastUpdated ?? '-'}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}