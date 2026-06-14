import 'package:flutter/material.dart';
import '../main.dart'; // brings in the FileFormat enum

// ─── REMOVED: void main() and the MaterialApp wrapper. ────────────────────
// This screen is now pushed by Navigator from AgesChoiceScreen, so it's no
// longer the app root. The app already has a MaterialApp at the top — wrapping
// another one here would create a nested app and cause subtle bugs (lost
// navigation context, missing theme, etc.).
// Also removed the unused `dart:ui` import and the `keyboardHeight` variable.

class DownloadsScreen extends StatefulWidget {
  // ─── NEW: parameters coming from the previous screen ────────────────────
  final int ageIndex;        // 0, 1, or 2
  final String ageLabel;     // 'ages 0-4' etc.
  final FileFormat format;   // FileFormat.word or FileFormat.pdf

  const DownloadsScreen({
    super.key,
    required this.ageIndex,
    required this.ageLabel,
    required this.format,
  });

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

enum DownloadState { notDownloaded, loading, downloaded } /// state per file

class _DownloadsScreenState extends State<DownloadsScreen> {
  // ─── CHANGED: files list is now built in initState based on the params,
  //     not hard-coded. _mockFilesFor() picks the right mock list for the
  //     chosen age + format. Swap it for a real API/DB call later.
  late List<String> files;
  late List<DownloadState> _states;

  @override
  void initState() {
    super.initState();
    files = _mockFilesFor(widget.ageIndex, widget.format);
    _states = List.filled(files.length, DownloadState.notDownloaded);
  }

  // ─── NEW: mock data source. Replace with a real lookup later. ───────────
  // The extension matches the chosen format so _fileIcon picks the right
  // icon automatically — no extra logic needed.
  List<String> _mockFilesFor(int ageIndex, FileFormat format) {
    final ext = format == FileFormat.pdf ? 'pdf' : 'docx';

    // Three age groups × titles per group. Indexed by ageIndex.
    const titlesByAge = [
      // ages 0-4
      ['Elio and Cirrus Play Hide-and-Seek ', 'Galactic Grooves'],
      // ages 4-8
      ['Robin Hood and the Brave Forest Friends', 'Snow White and the Seven Dwarfelles'],
      // ages 8-12
      ['The Great Cloud-Catcher Adventure', 'The Last Spark of Aethelgard'],
    ];

    return titlesByAge[ageIndex].map((t) => '$t.$ext').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // background doesn't squash with keyboard
      extendBodyBehindAppBar: true,    // gradient flows behind the AppBar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 208, 216),
        // ─── CHANGED: title now reflects the selection so the user knows
        //     what they're looking at. Font size reduced from 35 → 26 because
        //     the title is longer now.
        title: Text(
          '${widget.ageLabel} — ${widget.format == FileFormat.pdf ? "PDF" : "Word"}',
          style: const TextStyle(
            fontFamily: 'MyDancingScript',
            fontSize: 26,
            color: Color.fromARGB(255, 74, 7, 46),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 193, 230, 247),
              Color.fromARGB(255, 244, 231, 192),
              Color.fromARGB(255, 218, 165, 175),
            ],
            stops: [0.0, 0.4, 0.9],
          ),
        ),
        // ─── NEW: SafeArea + Column layout for the "sticky bottom button"
        //     pattern. ListView lives inside Expanded so it eats all the
        //     leftover vertical space; the button is a sibling below it
        //     and stays at the bottom while the list scrolls.
        child: SafeArea(
          top: false, // AppBar already handles the top
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: _fileIcon(files[index]),
                        title: Text(files[index]),
                        subtitle: const Text('Tap to download'),
                        trailing: _trailingButton(index),
                      ),
                    );
                  },
                ),
              ),

              // ─── NEW: Upload Book button — matches the styled button
              //     design we built before (glassy-pink, outlined, dancing
              //     script font, elevated shadow). Uses Size(350, 55) since
              //     it's alone on the row; on narrow screens Flutter will
              //     shrink it to fit but it'll still try to stretch to 350.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    elevation: 8,
                    shadowColor: const Color.fromARGB(255, 91, 80, 94),
                    minimumSize: const Size(350, 55),
                    backgroundColor: const Color.fromARGB(255, 250, 234, 243),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 176, 39, 119),
                      width: 2,
                    ),
                    foregroundColor: const Color.fromARGB(255, 53, 1, 24),
                  ),
                  onPressed: _uploadBook,
                  icon: const Icon(Icons.upload_file, size: 26),
                  label: const Text(
                    'Upload Book',
                    style: TextStyle(
                      fontFamily: 'MyDancingScript',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── NEW: mock upload action. Replace with file-picker logic later. ─────
  void _uploadBook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload Book — mock action'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _fileIcon(String filename) {
    final ext = filename.split('.').last.toLowerCase(); // file extension
    IconData icon = Icons.insert_drive_file;
    Color color = Colors.grey;

    if (ext == 'pdf') {
      icon = Icons.picture_as_pdf;
      color = const Color.fromARGB(255, 218, 165, 175);
    } else if (['doc', 'docx'].contains(ext)) {
      icon = Icons.description;
      color = const Color.fromARGB(255, 251, 189, 201);
    }


    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  /// Future is Dart's way of representing a value that doesn't exist yet
  /// but will eventually arrive.
  Future<void> _download(int index) async {
    setState(() {
      _states[index] = DownloadState.loading;
    });

    await Future.delayed(const Duration(seconds: 2)); // fake download

    if (!mounted) return; // user navigated away mid-download → bail
    setState(() {
      _states[index] = DownloadState.downloaded;
    });
  }

  Widget _trailingButton(int index) {
    final state = _states[index];

    if (state == DownloadState.loading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final isDone = state == DownloadState.downloaded;
    return TextButton(
      onPressed: isDone
          ? () { /* open file logic later */ }
          : () => _download(index),
      style: TextButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade50,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(isDone ? 'OPEN' : 'GET'),
    );
  }
}