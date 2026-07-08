import 'package:flutter/material.dart';

class SpeedSlider extends StatelessWidget {
  final double speed;
  final ValueChanged<double> onChanged;

  const SpeedSlider({
    super.key,
    required this.speed,
    required this.onChanged,
  });

  static const _speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0, 4.0];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              'Speed',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Row(
            children: [
              const Text('0.25x', style: TextStyle(fontSize: 11)),
              Expanded(
                child: Slider(
                  value: speed.clamp(0.25, 4.0),
                  min: 0.25,
                  max: 4.0,
                  divisions: 8,
                  label: '${speed.toStringAsFixed(2)}x',
                  onChanged: onChanged,
                ),
              ),
              const Text('4x', style: TextStyle(fontSize: 11)),
            ],
          ),
          // Quick preset chips
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _speeds.map((s) {
              final selected = s == speed;
              return ChoiceChip(
                label: Text('${s}x'),
                selected: selected,
                onSelected: (_) => onChanged(s),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
