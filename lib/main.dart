import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Recipe {
  final String title;
  final String description;
  final String author;

  Recipe({required this.title, required this.description, required this.author});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<List<Recipe>> _recipes = ValueNotifier<List<Recipe>>([
    Recipe(
      title: 'Creamy Tobacco',
      description: 'Tabacco dolce con vaniglia e un tocco di caramello.',
      author: 'Marco',
    ),
    Recipe(
      title: 'Fruity Mix',
      description: 'Fragola + Mango + un pizzico di menta.',
      author: 'Luca',
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VapeLab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: RootPage(recipesNotifier: _recipes),
    );
  }

  @override
  void dispose() {
    _recipes.dispose();
    super.dispose();
  }
}

class RootPage extends StatefulWidget {
  final ValueNotifier<List<Recipe>> recipesNotifier;
  const RootPage({super.key, required this.recipesNotifier});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'VapeLab',
    'Ricette',
    'Aggiungi',
    'Profilo',
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: isWide ? null : Drawer(child: _buildNavList()),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.list), label: Text('Ricette')),
                NavigationRailDestination(
                    icon: Icon(Icons.add), label: Text('Aggiungi')),
                NavigationRailDestination(
                    icon: Icon(Icons.person), label: Text('Profilo')),
              ],
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildNavList() {
    return ListView(
      children: [
        DrawerHeader(child: Text('VapeLab', style: TextStyle(fontSize: 24))),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          selected: _selectedIndex == 0,
          onTap: () => setState(() {
            _selectedIndex = 0;
            Navigator.of(context).pop();
          }),
        ),
        ListTile(
          leading: Icon(Icons.list),
          title: Text('Ricette'),
          selected: _selectedIndex == 1,
          onTap: () => setState(() {
            _selectedIndex = 1;
            Navigator.of(context).pop();
          }),
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Aggiungi'),
          selected: _selectedIndex == 2,
          onTap: () => setState(() {
            _selectedIndex = 2;
            Navigator.of(context).pop();
          }),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profilo'),
          selected: _selectedIndex == 3,
          onTap: () => setState(() {
            _selectedIndex = 3;
            Navigator.of(context).pop();
          }),
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return RecipesScreen(recipesNotifier: widget.recipesNotifier);
      case 2:
        return AddRecipeScreen(
          onAdd: (r) => widget.recipesNotifier.value = [...widget.recipesNotifier.value, r],
        );
      case 3:
      default:
        return ProfileScreen();
    }
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final String intro =
      'Benvenuto su VapeLab — spazio per appassionati di vaping: condividi ricette, recensioni e consigli.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('VapeLab', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 16),
            Text(intro, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.list),
                  label: Text('Esplora Ricette'),
                  onPressed: () => _navigateTo(context, 1),
                ),
                OutlinedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Aggiungi Ricetta'),
                  onPressed: () => _navigateTo(context, 2),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_RootPageState>();
    if (state != null) state.setState(() => state._selectedIndex = index);
  }
}

class RecipesScreen extends StatelessWidget {
  final ValueNotifier<List<Recipe>> recipesNotifier;
  const RecipesScreen({super.key, required this.recipesNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Recipe>>(
      valueListenable: recipesNotifier,
      builder: (context, recipes, _) {
        if (recipes.isEmpty) {
          return Center(child: Text('Nessuna ricetta ancora. Sii il primo a condividere!'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, i) {
            final r = recipes[i];
            return ListTile(
              title: Text(r.title),
              subtitle: Text('${r.author} · ${_short(r.description)}'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(recipe: r),
              )),
            );
          },
        );
      },
    );
  }

  String _short(String s, [int len = 80]) => s.length <= len ? s : '${s.substring(0, len)}…';
}

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Autore: ${recipe.author}', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(recipe.description),
          const SizedBox(height: 24),
          Text('Commenti e dettagli tecnici (da implementare)', style: TextStyle(color: Colors.grey[600])),
        ]),
      ),
    );
  }
}

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

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final r = Recipe(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        author: _authorCtrl.text.trim().isEmpty ? 'Anonimo' : _authorCtrl.text.trim(),
      );
      widget.onAdd(r);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ricetta aggiunta')));
      _titleCtrl.clear();
      _authorCtrl.clear();
      _descCtrl.clear();
      final state = context.findAncestorStateOfType<_RootPageState>();
      if (state != null) state.setState(() => state._selectedIndex = 1);
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder profilo; integrare autenticazione in futuro
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 12),
          Text('Utente', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Accedi per gestire le tue ricette e commenti', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.login), label: Text('Accedi (da implementare)')),
        ]),
      ),
    );
  }
}
