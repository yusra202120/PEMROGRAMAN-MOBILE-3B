import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

// ===================================
// SERVICE: FileService - util dasar untuk file handling
// ===================================

class FileService {
  // Mendapatkan direktori penyimpanan dokumen aplikasi
  Future<Directory> get documentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  // Menulis konten string ke file
  Future<File> writeFile(String fileName, String content) async {
    final Directory dir = await documentsDirectory;
    final File file = File(path.join(dir.path, fileName));
    return file.writeAsString(content);
  }

  // Membaca konten string dari file
  Future<String> readFile(String fileName) async {
    try {
      final Directory dir = await documentsDirectory;
      final File file = File(path.join(dir.path, fileName));
      return await file.readAsString();
    } catch (e) {
      return '';
    }
  }

  // Mengecek apakah file ada
  Future<bool> fileExists(String fileName) async {
    final Directory dir = await documentsDirectory;
    final File file = File(path.join(dir.path, fileName));
    return file.exists();
  }

  // Menghapus file berdasarkan nama file
  Future<void> deleteFile(String fileName) async {
    final Directory dir = await documentsDirectory;
    final File file = File(path.join(dir.path, fileName));
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Menghapus file berdasarkan path absolut (digunakan oleh NoteService)
  Future<void> deleteNoteByPath(String filePath) async {
    final File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

// ===================================
// SERVICE: DirectoryService - util directory management
// ===================================

class DirectoryService {
  final FileService _fileService = FileService();

  // Membuat direktori baru jika belum ada
  Future<Directory> createDirectory(String dirName) async {
    final Directory appDir = await _fileService.documentsDirectory;
    final Directory newDir = Directory(path.join(appDir.path, dirName));
    if (!await newDir.exists()) {
      await newDir.create(recursive: true);
    }
    return newDir;
  }

  // Mendapatkan daftar file dalam direktori
  Future<List<FileSystemEntity>> listFiles(String dirName) async {
    final Directory dir = await createDirectory(dirName);
    return dir.list().toList();
  }

  // Menghapus direktori beserta isinya
  Future<void> deleteDirectory(String dirName) async {
    final Directory appDir = await _fileService.documentsDirectory;
    final Directory dir = Directory(path.join(appDir.path, dirName));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}

// ===================================
// SERVICE: NoteService - simpan setiap note di file JSON
// ===================================

class NoteService {
  final DirectoryService _dirService = DirectoryService();
  final FileService _fileService = FileService();
  final String _notesDir = 'notes'; // Nama folder untuk menyimpan notes

  Future<void> saveNote({
    required String title,
    required String content,
  }) async {
    // 1. Buat direktori 'notes' jika belum ada
    final Directory notesDir = await _dirService.createDirectory(_notesDir);

    // 2. Buat nama file unik (timestamp in milliseconds)
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.json';
    final File file = File(path.join(notesDir.path, fileName));

    // 3. Buat data note dalam bentuk Map
    final Map<String, dynamic> noteData = {
      'title': title,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    };

    // 4. Tulis data ke file JSON
    await file.writeAsString(jsonEncode(noteData));
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final Directory notesDir = await _dirService.createDirectory(_notesDir);
    final List<FileSystemEntity> files = await notesDir.list().toList();

    List<Map<String, dynamic>> notes = [];
    for (var entity in files) {
      if (entity is File && entity.path.endsWith('.json')) {
        // 1. Baca konten file
        final String content = await (entity as File).readAsString();
        
        // 2. Decode JSON
        Map<String, dynamic> data = jsonDecode(content);
        
        // 3. Tambahkan path file untuk keperluan delete/detail
        data['file_path'] = entity.path;
        
        notes.add(data);
      }
    }

    // Urutkan dari terbaru (berdasarkan created_at)
    notes.sort((a, b) => b['created_at'].toString().compareTo(a['created_at'].toString()));
    
    return notes;
  }

  // Menghapus note berdasarkan path file absolut
  Future<void> deleteNoteByPath(String filePath) async {
    await _fileService.deleteNoteByPath(filePath);
  }
}

// ===================================
// MAIN APP
// ===================================

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes (Local File)',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const NotesPage(),
    ); // MaterialApp
  }
}

// ===================================
// UI: NotesPage (Menampilkan daftar notes)
// ===================================

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NoteService _noteService = NoteService();
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _noteService.getAllNotes();
    setState(() => _notes = notes);
  }

  // Navigasi ke AddNotePage dan muat ulang notes jika berhasil
  Future<void> _addNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );
    // Jika result == true (catatan berhasil disimpan), muat ulang daftar notes
    if (result == true) {
      _loadNotes();
    }
  }

  // Menghapus note dan memuat ulang daftar
  Future<void> _deleteNote(String filePath) async {
    await _noteService.deleteNoteByPath(filePath);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: _notes.isEmpty
          ? const Center(child: Text('Belum ada catatan.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    title: Text(note['title'] ?? 'No Title'),
                    subtitle: Text(
                      note['content'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Tombol Hapus
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteNote(note['file_path']),
                    ),
                    // Navigasi ke Detail
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailPage(note: note),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ===================================
// UI: AddNotePage – form untuk menulis note baru
// ===================================

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final NoteService _noteService = NoteService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Isi semua field dulu!')),
        );
      }
      return;
    }

    await _noteService.saveNote(
      title: _titleController.text,
      content: _contentController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan disimpan!')),
      );
      // Kembali ke NotesPage dengan hasil true (berhasil simpan)
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Judul
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 10),
            // Isi Catatan (Expanded agar mengisi sisa ruang)
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Isi Catatan'),
                expands: true,
                maxLines: null, // Penting agar bisa multiple lines
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Simpan
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
              onPressed: _saveNote,
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================
// UI: NoteDetailPage – menampilkan isi note
// ===================================

class NoteDetailPage extends StatelessWidget {
  final Map<String, dynamic> note;

  const NoteDetailPage({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note['title'] ?? 'Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(note['content'] ?? ''),
      ),
    );
  }
}