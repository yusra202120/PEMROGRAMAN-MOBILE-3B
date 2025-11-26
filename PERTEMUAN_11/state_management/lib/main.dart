import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// =================================================================
// 1. MODEL SEDERHANA – Data dan Business Logic
// =================================================================
/// Kelas yang menyimpan status aplikasi (data) dan logika turunan.
class AppSettings {
  bool isDarkMode = false;
  String userName = "Teman";
  int fontSize = 20;

  Color get backgroundColor {
    // Getter untuk warna latar belakang
    return isDarkMode ? Colors.grey[900]! : Colors.white;
  }

  Color get textColor {
    // Getter untuk warna teks
    return isDarkMode ? Colors.white : Colors.black;
  }

  String get greeting {
    // Getter untuk pesan sapaan
    return "Halo, $userName!";
  }
}

// =================================================================
// 2. VIEW + STATE (StatefulWidget)
// =================================================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Menginisialisasi Model
  AppSettings settings = AppSettings();

  // FUNGSI UNTUK UPDATE MODEL (Fungsi-fungsi ini memanggil setState)
  
  void toggleTheme() {
    // Mengubah status Dark Mode
    setState(() {
      settings.isDarkMode = !settings.isDarkMode;
    });
  }

  void updateName(String newName) {
    // Mengubah nama pengguna
    setState(() {
      settings.userName = newName;
    });
  }

  void increaseFont() {
    // Menambah ukuran font
    setState(() {
      settings.fontSize += 2;
    });
  }

  void decreaseFont() {
    // Mengurangi ukuran font (minimal 12)
    setState(() {
      if (settings.fontSize > 12) {
        settings.fontSize -= 2;
      }
    });
  }

  // =================================================================
  // 3. VIEW (Tampilan UI/Widget)
  // =================================================================
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menggunakan theme Dark/Light berdasarkan state
      theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        backgroundColor: settings.backgroundColor,
        appBar: AppBar(
          title: const Text('Aplikasi Settings Sederhana'),
          backgroundColor: settings.isDarkMode ? Colors.blueGrey[800] : Colors.blue,
        ),
        body: SingleChildScrollView( // Tambahkan ini agar tidak error saat keyboard muncul
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Agar widget melebar
            children: [
              // TAMPILKAN GREETING
              Text(
                settings.greeting,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: settings.fontSize.toDouble(),
                  color: settings.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 30),

              // STATUS THEME (Container dengan Switch)
              _buildSettingContainer(
                children: [
                  Text(
                    'Mode: ${settings.isDarkMode ? "Gelap 🌙" : "Terang ☀️"}',
                    style: TextStyle(color: settings.textColor, fontSize: 16),
                  ),
                  Switch(
                    value: settings.isDarkMode,
                    onChanged: (value) => toggleTheme(),
                    activeColor: Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // INPUT NAMA (TextField)
              TextField(
                onChanged: updateName,
                // Menggunakan settings.textColor untuk styling
                decoration: InputDecoration(
                  labelText: 'Ubah Nama',
                  labelStyle: TextStyle(color: settings.textColor),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: settings.isDarkMode ? Colors.grey[800] : Colors.grey[100],
                ),
                style: TextStyle(color: settings.textColor),
              ),

              const SizedBox(height: 20),

              // UKURAN FONT (Container dengan tombol increase/decrease)
              _buildSettingContainer(
                children: [
                  Column(
                    children: [
                      Text(
                        'Ukuran Font: ${settings.fontSize}',
                        style: TextStyle(color: settings.textColor, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: decreaseFont,
                            icon: Icon(Icons.remove_circle, color: settings.textColor),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: increaseFont,
                            icon: Icon(Icons.add_circle, color: settings.textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // PREVIEW TEXT
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: settings.textColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Ini adalah preview text dengan ukuran font ${settings.fontSize}',
                  style: TextStyle(
                    fontSize: settings.fontSize.toDouble(),
                    color: settings.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        // Floating Button untuk toggle theme
        floatingActionButton: FloatingActionButton(
          onPressed: toggleTheme,
          child: Icon(settings.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          backgroundColor: settings.isDarkMode ? Colors.blueGrey[800] : Colors.blue,
        ),
      ),
    );
  }

  // Metode pembantu untuk membuat Container pengaturan yang konsisten
  Widget _buildSettingContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: settings.isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}