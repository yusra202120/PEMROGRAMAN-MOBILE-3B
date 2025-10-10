import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Fungsi utama yang menjalankan aplikasi Flutter.
void main() {
  runApp(const MyApp());
}

// Widget utama aplikasi. Ini adalah StatelessWidget karena hanya mengatur tampilan dasar aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah widget inti yang menyediakan struktur aplikasi material design.
    return MaterialApp(
      title: 'My Profile & Counter App',
      debugShowCheckedModeBanner: false,
      // BONUS: Mengatur tema kustom untuk aplikasi (warna ungu gelap).
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // Mengatur font default aplikasi menggunakan Google Fonts.
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// MainScreen adalah StatefulWidget yang mengelola state navigasi antar halaman.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // State untuk melacak halaman mana yang sedang aktif (0 untuk Profil, 1 untuk Counter).
  int _selectedIndex = 0;

  // Daftar semua halaman yang bisa diakses melalui BottomNavigationBar.
  final List<Widget> _pages = [
    const ProfilePage(), // Halaman Profil (StatelessWidget)
    const CounterPage(), // Halaman Counter (StatefulWidget)
  ];

  // Fungsi yang dipanggil saat item di BottomNavigationBar ditekan.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar (AppBar, body, BottomNavigationBar).
    return Scaffold(
      // Body akan menampilkan halaman yang sesuai berdasarkan _selectedIndex.
      body: _pages[_selectedIndex],

      // Navigasi Antar Halaman menggunakan BottomNavigationBar.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Item untuk Halaman Profil
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          // Item untuk Halaman Counter
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Counter',
          ),
        ],
        currentIndex: _selectedIndex, // Menunjukkan item mana yang sedang aktif
        selectedItemColor: Colors.deepPurple, // Warna item yang dipilih
        onTap: _onItemTapped, // Fungsi yang dipanggil saat item diklik
      ),
    );
  }
}

// ====================================================================
// 1. HALAMAN PROFIL (StatelessWidget)
// ====================================================================

// ProfilePage adalah StatelessWidget karena tampilannya statis dan tidak berubah.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Contoh data profil
  final String nama = 'Yusra Yusuf';
  final String nim = '2341760044';
  final String jurusan = 'Teknologi Informasi';
  final String email = 'dynamic_jared200@gmail.com';
  final String telepon = '+62 812-3456-7890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul "Profil Mahasiswa"
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      // Padding di sekitar seluruh konten profil
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Column digunakan untuk menyusun widget secara vertikal
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Widget FlutterLogo
              const FlutterLogo(size: 80.0),
              const SizedBox(height: 20),

              // Foto Profil (Image) - DIPERBAIKI
              Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/foto_saya.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.deepPurple.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Nama, NIM, dan Jurusan
              // Menggunakan Text dengan custom font (Inter via GoogleFonts)
              Text(
                nama,
                style: GoogleFonts.oswald(
                  // Contoh font berbeda
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'NIM: $nim',
                style: GoogleFonts.inter(fontSize: 18, color: Colors.grey[700]),
              ),
              Text(
                'Jurusan: $jurusan',
                style: GoogleFonts.inter(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: $email',
                style: GoogleFonts.inter(fontSize: 18, color: Colors.grey[700]),
              ),
              Text(
                'Telepon: $telepon',
                style: GoogleFonts.inter(fontSize: 18, color: Colors.grey[700]),
              ),

              const Divider(height: 40, thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// 2. HALAMAN COUNTER (StatefulWidget)
// ====================================================================

// CounterPage adalah StatefulWidget karena state (nilai counter) akan berubah.
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // State: Variabel yang nilainya akan berubah dan mempengaruhi tampilan UI.
  int _counter = 0;

  // Fungsi untuk menambah angka.
  void _incrementCounter() {
    // setState memberi tahu Flutter untuk membangun ulang widget dengan nilai state baru.
    setState(() {
      _counter++;
    });
  }

  // Fungsi untuk mengurangi angka.
  void _decrementCounter() {
    setState(() {
      // Pastikan angka tidak negatif
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  // Fungsi untuk mereset angka ke 0.
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      // Center untuk menempatkan angka dan tombol di tengah layar.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Nilai saat ini:',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            // Tampilan angka di tengah layar.
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontSize: 100,
              ),
            ),
            const SizedBox(height: 50),

            // Row untuk menyusun tombol secara horizontal.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Tombol - (ElevatedButton)
                ElevatedButton(
                  onPressed: _decrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange, // Warna kustom
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('-', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 20),

                // Tombol Reset (OutlinedButton)
                OutlinedButton(
                  onPressed: _resetCounter,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.deepPurple,
                    ), // Warna garis tepi
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ),
                const SizedBox(width: 20),

                // Tombol + (ElevatedButton)
                ElevatedButton(
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('+', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ],
        ),
      ),

      // FloatingActionButton yang juga bisa menambah angka.
      floatingActionButton: FloatingActionButton(
        onPressed:
            _incrementCounter, // Menggunakan fungsi yang sama untuk menambah
        tooltip: 'Tambah Angka',
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}