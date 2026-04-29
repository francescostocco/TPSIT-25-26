import 'package:flutter/material.dart';

/// Widget per visualizzare un voto a stelle (1–5).
/// In quest'app le stelle sono solo informative (sola lettura).
class StelleWidget extends StatelessWidget {
  const StelleWidget({super.key, required this.voto, this.size = 22});

  final int voto;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          (i + 1) <= voto ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
}