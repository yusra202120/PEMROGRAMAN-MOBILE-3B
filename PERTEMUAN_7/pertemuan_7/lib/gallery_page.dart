import 'package:flutter/material.dart';

// --- DATA LOKAL (Simulasi Data) ---
// Menggunakan path relatif ke folder assets/images/
const List<String> galeriImages = [
  'assets/images/pic1.jpg',
  'assets/images/pic2.png',
  'assets/images/pic3.jpg',
  'assets/images/pic4.jpg',
  'assets/images/pic5.jpg',
  'assets/images/pic6.jpg',
];

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri Kampus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // Menggunakan GridView.builder untuk menampilkan item dalam bentuk kotak-kotak (grid)
        child: GridView.builder(
          // GridDelegate mengatur bagaimana grid disusun (contoh ini 2 kolom)
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Jumlah kolom
            crossAxisSpacing: 8.0, // Spasi antar kolom
            mainAxisSpacing: 8.0, // Spasi antar baris
            childAspectRatio: 1.2, // Rasio lebar/tinggi item
          ),
          itemCount: galeriImages.length,
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.antiAlias, // Memastikan gambar terpotong sesuai border card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    // MENGGUNAKAN GAMBAR DARI ASSET LOKAL
                    child: Image.asset(
                      galeriImages[index],
                      fit: BoxFit.cover,
                      // Penanganan error saat gambar tidak bisa dimuat
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, size: 40, color: Colors.red),
                              Text('Gagal Muat Gambar', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${index + 1}. Galeri Foto',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
