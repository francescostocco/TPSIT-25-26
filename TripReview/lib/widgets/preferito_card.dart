import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model.dart';
import '../notifier.dart';
import 'priorita_badge.dart';
import 'form_preferito_screen.dart';

/// Card di un preferito mostrato nella schermata Preferiti.
class PreferitoCard extends StatelessWidget {
  const PreferitoCard({super.key, required this.preferito});

  final Preferito preferito;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<StruttureNotifier>();
    final struttura = notifier.strutturaPer(preferito.strutturaId);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(struttura?.nome ?? '(Struttura non trovata)',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      if (struttura != null)
                        Text(
                          '${struttura.tipo.toUpperCase()} · ${struttura.luogo}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  enabled: !notifier.isOffline,
                  onSelected: (v) {
                    if (v == 'modifica') _apriForm(context);
                    if (v == 'elimina') _confermaElimina(context, notifier);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'modifica', child: Text('✏️  Modifica')),
                    PopupMenuItem(value: 'elimina', child: Text('💔  Rimuovi')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (preferito.note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '"${preferito.note}"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                PrioritaBadge(priorita: preferito.priorita),
                const Spacer(),
                Icon(Icons.calendar_today,
                    size: 12, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(preferito.dataAggiunta,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 10),
            if (!notifier.isOffline)
              Wrap(
                spacing: 6,
                children: ['bassa', 'media', 'alta'].map((p) {
                  final selected = preferito.priorita == p;
                  return ChoiceChip(
                    label: Text(p, style: const TextStyle(fontSize: 11)),
                    selected: selected,
                    onSelected: selected
                        ? null
                        : (_) async {
                            try {
                              await notifier.patchPriorita(preferito.id!, p);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Errore: $e')),
                                );
                              }
                            }
                          },
                    selectedColor: PrioritaBadge.colorePer(p).withOpacity(0.3),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _apriForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormPreferitoScreen(preferito: preferito),
      ),
    );
  }

  Future<void> _confermaElimina(
      BuildContext context, StruttureNotifier notifier) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rimuovi dai preferiti'),
        content: const Text('Vuoi rimuovere questo elemento dai preferiti?'),
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
        await notifier.deletePreferito(preferito.id!);
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