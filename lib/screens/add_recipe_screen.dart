import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../supabase_config.dart';

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

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
  if (_formKey.currentState?.validate() ?? false) {
    final recipe = Recipe(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      author: _authorCtrl.text.trim().isEmpty ? 'Anonimo' : _authorCtrl.text.trim(),
    );

    // Salva la ricetta su Supabase
    final response = await SupabaseConfig.client
        .from('recipes') // Nome della tabella
        .insert(recipe.toMap())
        .execute();

    // Controlla se la risposta ha uno status diverso da 201 (creato con successo)
    if (response.status != 201 || response.data == null) {
      print('Errore nell\'aggiunta della ricetta: ${response.status}');
      return;
    }

    widget.onAdd(recipe); // Aggiorna la lista locale
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ricetta aggiunta')));
    _titleCtrl.clear();
    _authorCtrl.clear();
    _descCtrl.clear();
  }
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 700),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('Aggiungi una nuova ricetta', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(labelText: 'Titolo'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Inserisci un titolo' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _authorCtrl,
                    decoration: InputDecoration(labelText: 'Autore (opzionale)'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: InputDecoration(labelText: 'Descrizione / ingredienti / note'),
                    minLines: 3,
                    maxLines: 6,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Inserisci una descrizione' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(onPressed: () {
                      _titleCtrl.clear();
                      _authorCtrl.clear();
                      _descCtrl.clear();
                    }, child: Text('Annulla')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _submit, child: Text('Aggiungi')),
                  ])
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}