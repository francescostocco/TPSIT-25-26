import 'package:flutter/material.dart';

/// Badge colorato per visualizzare la priorità di un preferito.
/// "alta" = rosso, "media" = arancione, "bassa" = verde.
class PrioritaBadge extends StatelessWidget {
  const PrioritaBadge({super.key, required this.priorita});

  final String priorita;

  static Color colorePer(String priorita) {
    switch (priorita) {
      case 'alta':  return Colors.red.shade400;
      case 'media': return Colors.orange.shade400;
      case 'bassa': return Colors.green.shade400;
      default:      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colore = colorePer(priorita);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colore.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colore, width: 1),
      ),
      child: Text(
        'Priorità ${priorita.toUpperCase()}',
        style: TextStyle(
          color: colore,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}