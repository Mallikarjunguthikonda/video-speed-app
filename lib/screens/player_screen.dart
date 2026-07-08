import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
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
