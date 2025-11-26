import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import untuk koneksi HTTP

// ===================================
// KONFIGURASI API
// ===================================

class ApiConfig {
  // Ganti baseURL ini sesuai dengan instance WireMock Cloud Anda
  // Contoh dari sesi sebelumnya: 'https://izvymq.wiremockapi.cloud'
  static const String baseURL = 'https://laffandi.wiremockapi.cloud';
  static const String usersEndpoint = '/users';

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

// ===================================
// MAIN APP
// ===================================

void main() {
  runApp(const WireMockApp());
}

class WireMockApp extends StatelessWidget {
  const WireMockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WireMock Cloud Demo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const UserPage(), // Home adalah UserPage
    );
  }
}

// ===================================
// UI: UserPage (StatefulWidget)
// ===================================

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // Controllers untuk Input Form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Variabel State
  List<dynamic> users = [];
  bool isLoading = false;
  String? errorMessage;
  String? postMessage; // Untuk menampilkan hasil POST

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Muat data pertama kali
  }

  // /// GET users
  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final url = Uri.parse('${ApiConfig.baseURL}${ApiConfig.usersEndpoint}');

    try {
      final response = await http
          .get(url, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decode JSON array
        final List<dynamic> data = jsonDecode(response.body);
        setState(() => users = data);
      } else {
        setState(() => errorMessage = 'Error ${response.statusCode}');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // /// POST new user
  Future<void> addUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama & Email tidak boleh kosong!')),
        );
      }
      return;
    }

    final url = Uri.parse('${ApiConfig.baseURL}${ApiConfig.usersEndpoint}');
    final body = jsonEncode({'name': name, 'email': email});

    try {
      final response = await http
          .post(url, headers: ApiConfig.headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        setState(() {
          // Ambil pesan dari respons, atau gunakan pesan default
          postMessage = result['message'] ?? 'User berhasil ditambahkan!'; 
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(postMessage!)),
          );
        }
        _nameController.clear();
        _emailController.clear();
        fetchUsers(); // Muat ulang daftar setelah POST berhasil
      } else {
        setState(() {
          postMessage = 'Gagal menambah user (${response.statusCode})';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(postMessage!)),
          );
        }
      }
    } catch (e) {
      setState(() => postMessage = 'Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(postMessage!)),
        );
      }
    }
  }

  // /// WIDGET BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WireMock Cloud - Users')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input form
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Tambah User'),
              onPressed: addUser,
            ),
            const SizedBox(height: 20),

            // Tampilan Pesan POST (jika ada)
            if (postMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  postMessage!,
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(height: 20),
            const Divider(),

            // Daftar User
            const Text(
              'Daftar User',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            
            // Data List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : users.isEmpty
                          ? const Center(child: Text('Belum ada data.'))
                          : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                      child: Text('${user['id']}')),
                                  title: Text(user['name'] ?? 'No Name'),
                                  subtitle: Text(user['email'] ?? 'No Email'),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}