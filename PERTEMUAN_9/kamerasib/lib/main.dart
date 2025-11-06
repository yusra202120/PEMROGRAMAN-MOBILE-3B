import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    controller = CameraController(_cameras[0], ResolutionPreset.high);

    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Fungsi untuk mengambil foto dan menyimpannya
  Future<void> _takePicture() async {
    if (!controller.value.isInitialized) {
      debugPrint("Camera not initialized");
      return;
    }

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String pictureDir = '${appDir.path}/Pictures';
      await Directory(pictureDir).create(recursive: true);

      final String filePath = join(
        pictureDir,
        'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await controller.takePicture().then((XFile file) async {
        await file.saveTo(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('📸 Gambar disimpan di $filePath')),
        );
      });
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            CameraPreview(controller),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: _takePicture,
                  child: const Icon(Icons.camera, color: Colors.black, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
