import 'package:flutter/material.dart';

/// Chip per visualizzare una caratteristica/servizio della struttura
/// (es. piscina, wifi, parcheggio).
class CaratChip extends StatelessWidget {
  const CaratChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.teal.shade700),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.teal.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}