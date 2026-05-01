import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model.dart';
import '../notifier.dart';

/// Form per aggiungere ai preferiti (POST) o modificare un preferito (PUT).
class FormPreferitoScreen extends StatefulWidget {
  const FormPreferitoScreen({
    super.key,
    this.preferito,
    this.strutturaId,
  }) : assert(preferito != null || strutturaId != null,
            'Devi fornire o un preferito da modificare o uno strutturaId per crearne uno nuovo');

  final Preferito? preferito;
  final String? strutturaId;

  @override
  State<FormPreferitoScreen> createState() => _FormPreferitoScreenState();
}

class _FormPreferitoScreenState extends State<FormPreferitoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _note;
  String _priorita = 'media';
  bool _isLoading = false;

  bool get _isModifica => widget.preferito != null;

  @override
  void initState() {
    super.initState();
    _note = TextEditingController(text: widget.preferito?.note ?? '');
    _priorita = widget.preferito?.priorita ?? 'media';
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _salva() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final notifier = context.read<StruttureNotifier>();
    final oggi = DateTime.now().toIso8601String().substring(0, 10);

    final dati = Preferito(
      id: widget.preferito?.id,
      strutturaId: widget.preferito?.strutturaId ?? widget.strutturaId!,
      note: _note.text.trim(),
      priorita: _priorita,
      dataAggiunta: widget.preferito?.dataAggiunta ?? oggi,
    );

    try {
      if (_isModifica) {
        await notifier.updatePreferito(dati);
      } else {
        await notifier.addPreferito(dati);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isModifica
              ? 'Preferito aggiornato'
              : 'Aggiunto ai preferiti'),
          backgroundColor: Colors.teal,
        ));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<StruttureNotifier>();
    final strutturaId = widget.preferito?.strutturaId ?? widget.strutturaId!;
    final struttura = notifier.strutturaPer(strutturaId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isModifica ? 'Modifica preferito' : 'Aggiungi ai preferiti'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (struttura != null) ...[
                Text(struttura.nome,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal)),
                Text('${struttura.tipo.toUpperCase()} · ${struttura.luogo}',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const Divider(height: 24),
              ],
              TextFormField(
                controller: _note,
                decoration: const InputDecoration(
                  labelText: 'Note personali',
                  hintText: 'Es. Da prenotare per l\'estate',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              Text('Priorità', style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'bassa', label: Text('Bassa')),
                  ButtonSegment(value: 'media', label: Text('Media')),
                  ButtonSegment(value: 'alta', label: Text('Alta')),
                ],
                selected: {_priorita},
                onSelectionChanged: (s) =>
                    setState(() => _priorita = s.first),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salva,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(_isModifica
                          ? 'Aggiorna'
                          : 'Aggiungi ai preferiti'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}