import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ===================================
// MAIN APP
// ===================================

void main() {
  runApp(const PokeApp());
}

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeAPI Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const PokemonPage(),
    );
  }
}

// ===================================
// UI: PokemonPage (StatefulWidget)
// ===================================

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  // Variabel State
  Map<String, dynamic>? pokemonData; // Untuk menyimpan data yang diterima
  bool isLoading = false;
  String? error; // Untuk menyimpan pesan error

  @override
  void initState() {
    super.initState();
    fetchPokemon(); // Otomatis ambil data saat pertama kali inisialisasi
  }

  // /// Metode untuk mengambil data Pokémon (Ditto)
  Future<void> fetchPokemon() async {
    setState(() {
      isLoading = true;
      error = null;
      // Membersihkan data sebelumnya saat memuat ulang
      // pokemonData = null; 
    });

    try {
      final response = await http
          // Mengambil data Ditto dari PokeAPI
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/ditto'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        setState(() {
          // Mendecode body respons HTTP ke Map
          pokemonData = jsonDecode(response.body);
        });
      } else {
        setState(() {
          error = 'Gagal memuat data. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // /// Widget untuk membangun Card Pokémon
  Widget _buildPokemonCard() {
    // Memastikan pokemonData tidak null sebelum diakses
    if (pokemonData == null) {
      return const Center(child: Text('Tidak ada data Pokémon.'));
    }

    // Mengambil data dengan null check operator (??)
    final name = pokemonData!['name'] ?? '-';
    final id = pokemonData!['id']?.toString() ?? '-';
    final height = pokemonData!['height']?.toString() ?? '-';
    final weight = pokemonData!['weight']?.toString() ?? '-';
    
    // Mengambil sprite dari nested Map
    final sprite = pokemonData!['sprites']?['front_default'] ?? 
        'https://via.placeholder.com/150'; // Placeholder jika sprite tidak ada

    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gambar Sprite
            Image.network(
              sprite,
              width: 150,
              height: 150,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => 
                  Image.network('https://via.placeholder.com/150'), // Tampilkan placeholder jika gagal load
            ),
            const SizedBox(height: 10),
            // Nama
            Text(
              name.toString().toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            // Detail
            Text('ID: $id'),
            Text('Height: $height'),
            Text('Weight: $weight'),
          ],
        ),
      ),
    ); // Card
  }

  // /// WIDGET BUILD (Implementasi utama UI)
  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (error != null) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(error!, textAlign: TextAlign.center),
        ),
      );
    } else if (pokemonData != null) {
      content = _buildPokemonCard();
    } else {
      content = const Center(child: Text('Tekan tombol refresh untuk memuat data.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('PokeAPI - Ditto')),
      body: Center(child: content),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchPokemon,
        tooltip: 'Refresh Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}