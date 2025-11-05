import 'package:flutter/material.dart';
import 'routes.dart';

// --- DATA MOCKUP (Simulasi Data) ---
const Map<String, dynamic> dataMahasiswa = {
  'nama': 'Yusra Yusuf',
  'nim': '2341760044',
  'prodi': 'Sistem Informasi Bisnis',
  'semester': 5,
};

const List<String> mataKuliah = [
  'Pemrograman Aplikasi Mobile (Flutter)',
  'Struktur Data & Algoritma',
  'Basis Data Lanjut',
  'Kecerdasan Buatan',
  'Jaringan Komputer',
  'Sistem Informasi Geografis',
];

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Widget pembantu untuk menampilkan info detail (menggunakan Row)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Label (menggunakan Container untuk styling)
          Container(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Bagian Value
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat card Mata Kuliah
  Widget _buildMatkulList() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Mata Kuliah Semester 5',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.blueGrey),
          // Menggunakan ListView.builder untuk daftar Matkul
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mataKuliah.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.book_outlined, color: Colors.blue),
                title: Text(mataKuliah[index]),
                trailing: const Icon(Icons.arrow_right),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
      ),
      body: SingleChildScrollView(
        child: Column( // Column adalah layout utama secara vertikal
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Bagian Header Profil (Container) ---
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.blue.shade50, // Latar belakang abu-abu muda
              child: Column(
                children: [
                  // Menggunakan gambar lokal dari assets/images/avatar.png
                  const CircleAvatar( 
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/avatar.jpeg'),
                    backgroundColor: Colors.blueGrey, // Warna fallback jika gambar tidak dimuat
                    child: SizedBox.shrink(), // Hapus Icon karena sudah ada gambar
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dataMahasiswa['nama']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: ${dataMahasiswa['nim']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // --- Bagian Detail Informasi (Card & Column/Row) ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Dasar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Nama Lengkap', dataMahasiswa['nama']!),
                      _buildDetailRow('NIM', dataMahasiswa['nim']!),
                      _buildDetailRow('Program Studi', dataMahasiswa['prodi']!),
                      _buildDetailRow('Semester', dataMahasiswa['semester']!.toString()),
                    ],
                  ),
                ),
              ),
            ),

            // --- Bagian Daftar Mata Kuliah (ListView) ---
            _buildMatkulList(),
            
            // --- Tombol Navigasi ke Halaman Galeri ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigasi menggunakan Named Routes
                  Navigator.pushNamed(context, AppRoutes.gallery);
                },
                icon: const Icon(Icons.image_search, size: 24),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Lihat Galeri Kampus',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Memberi warna berbeda agar menarik
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
