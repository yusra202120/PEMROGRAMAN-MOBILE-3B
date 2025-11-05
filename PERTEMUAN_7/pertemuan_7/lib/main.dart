import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan bentuk Card yang diinginkan
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return MaterialApp(
      title: 'Aplikasi Profil Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        
        // --- SOLUSI TERBAIK: Menggunakan CardThemeData secara eksplisit ---
        cardTheme: CardThemeData(
          shape: cardShape,
          elevation: 2,
        ),
        // --- END SOLUSI ---
      ),
      
      // Menggunakan Named Routes yang diambil dari routes.dart
      initialRoute: AppRoutes.profile,
      routes: routes,
    );
  }
}
