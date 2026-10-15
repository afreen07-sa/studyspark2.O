import 'dart:io';
 
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
 
/// Documents for any level, e.g.
///   folders: ['Class 6']                                 -> class-wise
///   folders: ['Class 6', 'Mathematics', 'Numbers']       -> chapter-wise
class DocumentsPage extends StatefulWidget {
  final String title;
  final List<String> folders;
 
  const DocumentsPage({
    super.key,
    required this.title,
    required this.folders,
  });
 
  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}
 
class _DocumentsPageState extends State<DocumentsPage> {
  List<File> files = [];
  bool loading = true;
 
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      loading = false;
    } else {
      _load();
    }
  }
 
  String _safe(String s) => s.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
 
  Future<Directory> _dir() async {
    final base = await getApplicationDocumentsDirectory();
    final sep = Platform.pathSeparator;
    final path = [
      base.path,
      'documents',
      ...widget.folders.map(_safe),
    ].join(sep);
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
 
  Future<void> _load() async {
    final dir = await _dir();
    final list = dir.listSync().whereType<File>().toList()
      ..sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
    if (!mounted) return;
    setState(() {
      files = list;
      loading = false;
    });
  }
 
  Future<void> _upload() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt'],
    );
    if (result == null) return;
 
    final dir = await _dir();
    int added = 0;
    for (final picked in result.files) {
      if (picked.path == null) continue;
      await File(picked.path!).copy(
        '${dir.path}${Platform.pathSeparator}${picked.name}',
      );
      added++;
    }
 
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$added document(s) uploaded')),
    );
  }
 
  Future<void> _open(File file) async {
    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open file: ${result.message}')),
      );
    }
  }
 
  Future<void> _delete(File file) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete document?'),
        content: Text(_name(file)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await file.delete();
    await _load();
  }
 
  String _name(File f) => f.path.split(Platform.pathSeparator).last;
 
  String _size(File f) {
    final bytes = f.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
 
  IconData _icon(File f) {
    final n = _name(f).toLowerCase();
    if (n.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (n.endsWith('.ppt') || n.endsWith('.pptx')) return Icons.slideshow;
    if (n.endsWith('.doc') || n.endsWith('.docx')) return Icons.description;
    return Icons.insert_drive_file;
  }
 
  @override
  Widget build(BuildContext context) {
    final heading = '${widget.title} Documents';
 
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: Text(heading)),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Document upload is not supported in Chrome (web).\n'
              'Run the app on Windows or Android:\n'
              'flutter run -d windows',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }
 
    return Scaffold(
      appBar: AppBar(title: Text(heading)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _upload,
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : files.isEmpty
              ? const Center(
                  child: Text(
                    'No documents uploaded yet.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: Icon(_icon(file), color: Colors.blue),
                        title: Text(_name(file)),
                        subtitle: Text(_size(file)),
                        onTap: () => _open(file),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _delete(file),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
 
/// Class-wise documents (used by the upload icon on the Choose Class screen).
class ClassDocumentsPage extends StatelessWidget {
  final String className;
 
  const ClassDocumentsPage({super.key, required this.className});
 
  @override
  Widget build(BuildContext context) {
    return DocumentsPage(title: className, folders: [className]);
  }
}
 
