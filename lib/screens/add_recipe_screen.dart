import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../supabase_config.dart';
import 'package:uuid/uuid.dart';

class AddRecipeScreen extends StatefulWidget {
  final void Function(Recipe) onAdd;
  const AddRecipeScreen({super.key, required this.onAdd});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _hashtagsCtrl = TextEditingController();
  String _selectedType = 'MTL';
  String? _selectedRatio;
  bool _isPublic = true;
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _descCtrl.dispose();
    _hashtagsCtrl.dispose();
    super.dispose();
  }

  List<String> _parseHashtags(String input) {
    if (input.trim().isEmpty) return [];
    final parts = input.split(RegExp(r'[,\s]+'));
    return parts
        .map((s) => s.trim().replaceFirst(RegExp(r'^#'), ''))
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userId = SupabaseConfig.client.auth.currentUser?.id;
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Devi essere autenticato per aggiungere una ricetta')),
        );
      }
      return;
    }

    setState(() => _submitting = true);

    final uuid = Uuid();
    final parsedHashtags = _parseHashtags(_hashtagsCtrl.text);

    final payload = {
      'id': uuid.v4(),
      'name': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'author': _authorCtrl.text.trim().isEmpty ? 'Anonimo' : _authorCtrl.text.trim(),
      'type': _selectedType,
      'ratio': _selectedRatio!,
      'user_id': userId,
      'is_public': _isPublic,
      'hashtags': parsedHashtags,
    };

    try {
      final response = await SupabaseConfig.client
          .from('recipes')
          .insert(payload)
          .select()
          .execute();

      final status = response.status;
      debugPrint('INSERT /recipes status=$status body=${response.data}');

      if (status != null && status >= 200 && status < 300) {
        Map<String, dynamic> created;
        if (response.data != null) {
          // Supabase returns a list even for a single insert
          created = (response.data as List).first as Map<String, dynamic>;
        } else {
          created = Map<String, dynamic>.from(payload);
        }

        // Costruisci il modello in modo robusto
        try {
          final recipe = Recipe.fromMap(created);

          // Notifica il genitore in modo sicuro dopo il frame corrente
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            try {
              widget.onAdd(recipe);
            } catch (e) {
              debugPrint('Errore in widget.onAdd: $e');
            }
          });

          // reset dello stato prima di chiudere la schermata
          if (mounted) setState(() => _submitting = false);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ricetta aggiunta con successo')),
            );
            // Chiudi solo se la route può essere poppata (evita di poppare il root quando la schermata è una tab)
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        } catch (e) {
          debugPrint('Impossibile convertire la risposta in Recipe: $e');
          if (mounted) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ricetta aggiunta, ma errore interno')),
            );
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        }
      } else {
        debugPrint('Errore nell\'aggiunta della ricetta: status=$status body=${response.data}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Errore nell\'aggiunta della ricetta')),
          );
        }
      }
    } catch (e) {
      debugPrint('Eccezione durante INSERT: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore di rete o server')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = _submitting;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Aggiungi una nuova ricetta', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Inserisci un Nome' : null,
                      enabled: !disabled,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _authorCtrl,
                      decoration: const InputDecoration(labelText: 'Autore (opzionale)'),
                      enabled: !disabled,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(labelText: 'Descrizione / ingredienti / note'),
                      minLines: 3,
                      maxLines: 6,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Inserisci una descrizione' : null,
                      enabled: !disabled,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      items: ['MTL', 'DTL'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                      onChanged: disabled ? null : (value) {
                        setState(() {
                          _selectedType = value!;
                          _selectedRatio = null;
                        });
                      },
                      validator: (value) => value == null ? 'Seleziona un tipo' : null,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedRatio,
                      decoration: const InputDecoration(labelText: 'Rapporto VG/PG'),
                      items: (_selectedType == 'MTL' ? ['50/50', '60/40'] : ['70/30', '80/20'])
                          .map((ratio) => DropdownMenuItem(value: ratio, child: Text(ratio)))
                          .toList(),
                      onChanged: disabled ? null : (value) => setState(() => _selectedRatio = value),
                      validator: (value) => value == null ? 'Seleziona un rapporto VG/PG' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _hashtagsCtrl,
                      decoration: const InputDecoration(labelText: 'Hashtag (opzionali)', hintText: 'es: #fruttato, cremoso, menta'),
                      enabled: !disabled,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: _isPublic,
                      title: const Text('Rendi la ricetta pubblica'),
                      subtitle: const Text('Se pubblica, comparirà nella sezione Esplora'),
                      onChanged: disabled ? null : (v) => setState(() => _isPublic = v),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: disabled
                              ? null
                              : () {
                                  _titleCtrl.clear();
                                  _authorCtrl.clear();
                                  _descCtrl.clear();
                                  _hashtagsCtrl.clear();
                                  setState(() {
                                    _selectedType = 'MTL';
                                    _selectedRatio = null;
                                    _isPublic = true;
                                  });
                                },
                          child: const Text('Annulla'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: disabled ? null : () => _submit(),
                          child: SizedBox(
                            height: 18,
                            width: 100,
                            child: Center(
                              child: _submitting
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text('Aggiungi'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
