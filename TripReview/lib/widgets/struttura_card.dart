import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model.dart';
import '../notifier.dart';
import 'stelle_widget.dart';
import 'carat_chip.dart';
import 'form_preferito_screen.dart';

/// Card che rappresenta una struttura turistica nella lista principale.
class StrutturaCard extends StatelessWidget {
  const StrutturaCard({super.key, required this.struttura});

  final Struttura struttura;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<StruttureNotifier>();
    final preferito = notifier.preferitoPer(struttura.id);
    final isFavorito = preferito != null;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_iconaTipo(struttura.tipo),
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(struttura.nome,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(
                        '${struttura.tipo.toUpperCase()}  ·  ${struttura.luogo}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorito ? Icons.favorite : Icons.favorite_border,
                    color: isFavorito ? Colors.red : Colors.grey,
                    size: 28,
                  ),
                  tooltip: isFavorito
                      ? 'Rimuovi dai preferiti'
                      : 'Aggiungi ai preferiti',
                  onPressed: notifier.isOffline
                      ? null
                      : () => _gestisciPreferito(context, notifier, preferito),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StelleWidget(voto: struttura.stelle),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                CaratChip(icon: Icons.bed, label: '${struttura.camere} camere'),
                if (struttura.piscina)
                  const CaratChip(icon: Icons.pool, label: 'Piscina'),
                if (struttura.wifi)
                  const CaratChip(icon: Icons.wifi, label: 'WiFi'),
                if (struttura.colazione)
                  const CaratChip(icon: Icons.free_breakfast, label: 'Colazione'),
                if (struttura.parcheggio)
                  const CaratChip(icon: Icons.local_parking, label: 'Parcheggio'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              struttura.descrizione,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  String _iconaTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'hotel':        return '🏨';
      case 'b&b':          return '🏡';
      case 'campeggio':    return '⛺';
      case 'appartamento': return '🏠';
      default:             return '🏢';
    }
  }

  Future<void> _gestisciPreferito(BuildContext context,
      StruttureNotifier notifier, Preferito? esistente) async {
    if (esistente == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FormPreferitoScreen(strutturaId: struttura.id),
        ),
      );
    } else {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Rimuovi dai preferiti'),
          content: Text(
              'Vuoi rimuovere "${struttura.nome}" dai tuoi preferiti?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Annulla')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Rimuovi',
                    style: TextStyle(color: Colors.red))),
          ],
        ),
      );
      if (ok == true) {
        try {
          await notifier.deletePreferito(esistente.id!);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Errore: $e')),
            );
          }
        }
      }
    }
  }
}