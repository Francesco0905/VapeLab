import 'package:flutter/material.dart';
import '../supabase_config.dart';
import '../models/recipe.dart';

class ExploreScreen extends StatefulWidget {
  final void Function(int)? onNavigate;
  const ExploreScreen({super.key, this.onNavigate});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _ctrl = TextEditingController();
  bool _loading = false;
  List<Recipe> _results = [];
  String? _lastQuery;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final query = _ctrl.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _lastQuery = query;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _results = [];
    });

    try {
      final response = await SupabaseConfig.client
          .from('recipes')
          .select()
          .eq('is_public', true)
          .execute();

      final status = response.status;
      if (status == null || status < 200 || status >= 300 || response.data == null) {
        setState(() {
          _error = 'Errore nel caricamento delle ricette (status=$status)';
          _loading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error!)),
          );
        }
        return;
      }

      final data = response.data as List;
      final all = data.map((e) => Recipe.fromMap(e)).toList();

      final tokens = _tokenizeQuery(query);
      final resultsWithScore = <MapEntry<Recipe, int>>[];

      for (final r in all) {
        final score = _scoreRecipe(r, query, tokens);
        if (score > 0) resultsWithScore.add(MapEntry(r, score));
      }

      resultsWithScore.sort((a, b) => b.value.compareTo(a.value));
      final results = resultsWithScore.map((e) => e.key).toList();

      setState(() {
        _results = results;
        _lastQuery = query;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Eccezione durante la ricerca: $e';
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error!)),
        );
      }
    }
  }

  List<String> _tokenizeQuery(String q) {
    final raw = q.toLowerCase();
    final parts = raw.split(RegExp(r'[,\s]+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    return parts;
  }

  int _scoreRecipe(Recipe r, String rawQuery, List<String> tokens) {
    var score = 0;
    final q = rawQuery.toLowerCase();
    final name = r.name.toLowerCase();
    final desc = r.description.toLowerCase();
    final hashtags = r.hashtags.map((h) => h.toLowerCase()).toSet();

    // Exact title match = forte rilevanza
    if (name == q) score += 200;

    // Exact hashtag search (if user typed #tag or tag)
    for (final t in tokens) {
      final tClean = t.replaceFirst(RegExp(r'^#'), '');
      if (hashtags.contains(tClean)) score += 60;
    }

    // Partial title match
    if (name.contains(q)) score += 100;
    // Partial token match in title
    for (final t in tokens) {
      if (t.length >= 2 && name.contains(t)) score += 30;
    }

    // Description matches (weaker)
    if (desc.contains(q)) score += 20;
    for (final t in tokens) {
      if (t.length >= 3 && desc.contains(t)) score += 8;
    }

    // Hashtag partial matches (token contained in hashtag)
    for (final t in tokens) {
      final tClean = t.replaceFirst(RegExp(r'^#'), '');
      for (final h in hashtags) {
        if (h.contains(tClean) && tClean.isNotEmpty) score += 25;
      }
    }

    // Small boost by number of hashtag matches
    final matchedHashtags = hashtags.where((h) => tokens.any((t) => h == t.replaceFirst(RegExp(r'^#'), ''))).length;
    score += matchedHashtags * 10;

    return score;
  }

  void _showRecipeDialog(Recipe r) {
    showDialog(
      context: context,
      builder: (ctx) {
        final hashtags = r.hashtags;
        return AlertDialog(
          title: Text(r.name),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Autore: ${r.author}', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Tipo: ${r.type}'),
                const SizedBox(height: 8),
                Text('Rapporto VG/PG: ${r.ratio}'),
                const SizedBox(height: 12),
                Text(r.description),
                if (hashtags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text('Hashtags', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: hashtags.map((h) => Chip(label: Text('#$h'))).toList(),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  r.isPublic ? 'Visibilità: Pubblica (visibile in Esplora)' : 'Visibilità: Privata',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Chiudi'),
            ),
            // Opzionale: pulsante per andare alla schermata Ricette se si desidera
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(ctx).pop();
            //     if (widget.onNavigate != null) widget.onNavigate!.call(1);
            //   },
            //   child: const Text('Apri'),
            // ),
          ],
        );
      },
    );
  }

  Widget _buildResultTile(Recipe r) {
    return ListTile(
      title: Text(r.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${r.author} · ${r.type} · ${r.ratio}'),
          const SizedBox(height: 6),
          if (r.hashtags.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: r.hashtags.map((h) => Chip(label: Text('#$h', style: const TextStyle(fontSize: 12)))).toList(),
            ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.open_in_new),
        onPressed: () => _showRecipeDialog(r),
      ),
      onTap: () => _showRecipeDialog(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Esplora', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 12),
            Text(
              'Cerca ricette per titolo o hashtag. I risultati vengono ordinati per pertinenza.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: (_) => _performSearch(),
                    decoration: const InputDecoration(
                      labelText: 'Cerca per titolo o hashtag',
                      hintText: 'es: menta, torta fragola, #fruttato',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Cerca'),
                  onPressed: _loading ? null : _performSearch,
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (!_loading && _error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            if (!_loading && _lastQuery != null && _results.isEmpty && _error == null)
              Text('Nessun risultato per "$_lastQuery"', style: Theme.of(context).textTheme.bodyLarge),
            if (!_loading && _results.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) => _buildResultTile(_results[i]),
                ),
              ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }
}