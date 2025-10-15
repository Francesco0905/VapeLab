import 'package:flutter/material.dart';
import 'supabase_config.dart';
import 'models/recipe.dart';
import 'screens/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize(); // Inizializza Supabase
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<List<Recipe>> _recipes = ValueNotifier<List<Recipe>>([]);

  @override
  void initState() {
    super.initState();
    _fetchRecipes(); // Carica le ricette da Supabase
  }

  Future<void> _fetchRecipes() async {
  final response = await SupabaseConfig.client
      .from('recipes') // Nome della tabella Supabase
      .select()
      .execute();

  // Controlla se la risposta ha uno status diverso da 200 (successo)
  if (response.status != 200 || response.data == null) {
    print('Errore nel caricamento delle ricette: ${response.status}');
    return;
  }

  // Converte i dati in una lista di ricette
  final data = response.data as List;
  final recipes = data.map((e) => Recipe.fromMap(e)).toList();
  _recipes.value = recipes;
}

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
