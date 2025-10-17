import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../supabase_config.dart';
import '../services/recipe_service.dart';
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
  String _selectedType = 'MTL'; // Valore predefinito
  String? _selectedRatio; // Valore per il secondo dropdown

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
  final userId = SupabaseConfig.client.auth.currentUser?.id;

  if (userId == null) {
    print('Utente non autenticato');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Devi essere autenticato per aggiungere una ricetta')),
    );
    return;
  } 
  final uuid = Uuid();
  if (_formKey.currentState?.validate() ?? false) {
    final recipe = Recipe(
      id: uuid.v4(), // L'ID sarà generato automaticamente da Supabase
      name: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      author: _authorCtrl.text.trim().isEmpty ? 'Anonimo' : _authorCtrl.text.trim(),
      type: _selectedType,
      ratio: _selectedRatio!,
      userId: userId, // Associa la ricetta all'utente autenticato
    );

    final response = await SupabaseConfig.client
        .from('recipes')
        .insert(recipe.toMap())
        .execute();

    if (response.status == 201) {
      print('Ricetta aggiunta con successo');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ricetta aggiunta con successo')),
      );
      Navigator.of(context).pop(); // Torna indietro dopo l'aggiunta
    } else {
      print('Errore nell\'aggiunta della ricetta: ${response.status}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore nell\'aggiunta della ricetta')),
      );
    }
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Aggiungi una nuova ricetta',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Inserisci un Nome'
                          : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _authorCtrl,
                      decoration: InputDecoration(
                        labelText: 'Autore (opzionale)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: InputDecoration(
                        labelText: 'Descrizione / ingredienti / note',
                      ),
                      minLines: 3,
                      maxLines: 6,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Inserisci una descrizione'
                          : null,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: InputDecoration(labelText: 'Tipo'),
                      items: ['MTL', 'DTL'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                          _selectedRatio = null; // Resetta il secondo dropdown
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleziona un tipo' : null,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRatio,
                      decoration: InputDecoration(labelText: 'Rapporto VG/PG'),
                      items: (_selectedType == 'MTL'
                              ? ['50/50', '60/40']
                              : ['70/30', '80/20'])
                          .map((ratio) {
                        return DropdownMenuItem(
                          value: ratio,
                          child: Text(ratio),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRatio = value!;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleziona un rapporto VG/PG' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _titleCtrl.clear();
                            _authorCtrl.clear();
                            _descCtrl.clear();
                          },
                          child: Text('Annulla'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            print(
                              'Pulsante Aggiungi premuto',
                            ); // Log per verificare il click
                            _submit();
                          },
                          child: Text('Aggiungi'),
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
