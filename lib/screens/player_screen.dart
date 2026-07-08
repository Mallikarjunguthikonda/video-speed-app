import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/speed_slider.dart';

class PlayerScreen extends StatefulWidget {
  final String filePath;

  const PlayerScreen({super.key, required this.filePath});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _controller;
  double _speed = 1.0;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final controller = VideoPlayerController.file(
        File(widget.filePath),
      );
      _controller = controller;
      await controller.initialize();
      controller.play();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Video init error: $e');
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  void _onSpeedChanged(double speed) {
    setState(() => _speed = speed);
    _controller?.setPlaybackSpeed(speed);
  }

  Future<void> _exportVideo() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final outputPath = '${dir.path}/speed_${_speed}x_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Build FFmpeg command for speed change
      final command = _buildSpeedCommand(widget.filePath, outputPath, _speed);

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (!mounted) return;

      if (ReturnCode.isSuccess(returnCode)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved: speed_${_speed}x.mp4'),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  String _buildSpeedCommand(String input, String output, double speed) {
    final videoFilter = 'setpts=${1.0 / speed}*PTS';

    // atempo range is [0.5, 2.0], chain if needed
    String audioFilter = _buildAtempoFilter(speed);

    return '-i "$input" -filter:v "$videoFilter" -filter:a "$audioFilter" -c:v mpeg4 -c:a aac -y "$output"';
  }

  String _buildAtempoFilter(double speed) {
    if (speed >= 0.5 && speed <= 2.0) {
      return 'atempo=$speed';
    }
    // Chain atempo filters: atempo only supports 0.5-2.0
    final filters = <String>[];
    double remaining = speed;
    while (remaining > 2.0) {
      filters.add('atempo=2.0');
      remaining /= 2.0;
    }
    while (remaining < 0.5) {
      filters.add('atempo=0.5');
      remaining /= 0.5;
    }
    filters.add('atempo=$remaining');
    return filters.join(',');
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speed: ${_speed.toStringAsFixed(2)}x'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_alt),
            onPressed: _isInitialized ? _exportVideo : null,
            tooltip: 'Export video',
          ),
        ],
      ),
      body: _hasError
          ? _buildError()
          : _isInitialized
              ? _buildPlayer()
              : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Could not load video'),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: VideoPlayerWidget(controller: _controller!, speed: _speed),
          ),
        ),
        SpeedSlider(
          speed: _speed,
          onChanged: _onSpeedChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
