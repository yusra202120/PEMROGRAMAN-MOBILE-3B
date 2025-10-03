import 'package:flutter/material.dart';

void main() {
  // Fungsi main adalah titik awal eksekusi program.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp menyediakan kerangka kerja dasar untuk aplikasi Flutter.
    return MaterialApp(
      // Nonaktifkan banner "DEBUG" di pojok kanan atas.
      debugShowCheckedModeBanner: false,
      // Widget yang akan ditampilkan di layar utama aplikasi.
      home: Scaffold(
        // --- Bagian AppBar (Bilah Atas) ---
        appBar: AppBar(
          // title: Menampilkan teks di AppBar.
          title: const Text("Belajar Scaffold & AppBar"),
          // backgroundColor: Memberi warna pada AppBar (warna Teal).
          backgroundColor: Colors.teal,
          // actions: Daftar ikon di kanan (Search dan Settings).
          actions: const [
            Icon(Icons.search),
            Icon(Icons.settings),
          ],
        ),

        // --- Bagian Drawer (Menu Samping) ---
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
              // DrawerHeader (Header menu samping)
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              // List Tile 1
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              // List Tile 2
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
              ),
              // List Tile 3
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ],
          ),
        ),
        // --- Akhir Bagian Drawer ---

        // --- Bagian Body (Isi Utama) ---
        // body: Konten utama yang mengisi sebagian besar layar.
        body: const Center(
          // Center: Menempatkan widget anak (child) di tengah layar.
          child: Text("Ini Body Aplikasi"),
        ),

        // --- Bagian FloatingActionButton (Tombol Aksi Mengambang) ---
        // floatingActionButton: Tombol berbentuk lingkaran yang mengambang.
        floatingActionButton: FloatingActionButton(
          // onPressed: Fungsi yang dipanggil saat tombol ditekan (saat ini kosong).
          onPressed: () {
            // Logika aksi saat tombol diklik bisa ditambahkan di sini.
            print("Floating Action Button diklik!");
          },
          // child: Ikon di dalam tombol.
          child: const Icon(Icons.add),
        ),

        // --- Bagian BottomNavigationBar (Bilah Navigasi Bawah) ---
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
          // Anda dapat menambahkan properti seperti currentIndex dan onTap di sini
          // untuk mengontrol navigasi antar tab.
        ),
        // --- Akhir Bagian BottomNavigationBar ---
      ),
    );
  }
}