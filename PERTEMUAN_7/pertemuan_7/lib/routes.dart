import 'package:flutter/material.dart';
import 'gallery_page.dart';
import 'profile_page.dart';

// Nama-nama rute yang akan digunakan untuk navigasi
class AppRoutes {
  static const String profile = '/';
  static const String gallery = '/gallery';
}

// Map berisi semua rute yang didefinisikan untuk MaterialApp
final Map<String, WidgetBuilder> routes = {
  AppRoutes.profile: (context) => const ProfilePage(),
  AppRoutes.gallery: (context) => const GalleryPage(),
};
