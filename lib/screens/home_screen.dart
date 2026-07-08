import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickVideo(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlayerScreen(filePath: result.files.single.path!),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
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
              'Slow motion • Fast forward • Export',
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
