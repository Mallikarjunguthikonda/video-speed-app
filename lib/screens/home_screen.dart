import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickVideo(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withReadStream: true, // stream bytes for large files
      );

      if (result == null || result.files.single.path == null) return;
      if (!context.mounted) return;

      await _openVideo(context, result.files.single);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _openVideo(BuildContext context, PlatformFile file) async {
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final dir = await getTemporaryDirectory();
      final ext = file.name.contains('.')
          ? file.name.substring(file.name.lastIndexOf('.'))
          : '.mp4';
      final tempFile = File(
        '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}$ext',
      );

      // Copy content URI to temp file using stream
      if (file.readStream != null) {
        final sink = tempFile.openWrite();
        await file.readStream!.pipe(sink);
        await sink.flush();
        await sink.close();
      } else {
        throw Exception(
          'Cannot access this video file. Please try a different video.',
        );
      }

      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loading

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PlayerScreen(filePath: tempFile.path),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading video: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Speed Changer'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.speed,
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Change video playback speed',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Slow motion • Fast forward',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 48),
            FilledButton.icon(
              onPressed: () => _pickVideo(context),
              icon: const Icon(Icons.video_file, size: 28),
              label: const Text('Pick a Video', style: TextStyle(fontSize: 18)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
