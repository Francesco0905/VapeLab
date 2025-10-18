import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'home_screen.dart';
import 'recipes_screen.dart';
import 'add_recipe_screen.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';

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
    'Esplora',
  ];

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
              onDestinationSelected: _navigateTo,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  selectedIcon: Icon(Icons.list_alt),
                  label: Text('Ricette'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_outlined),
                  selectedIcon: Icon(Icons.add),
                  label: Text('Aggiungi'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Profilo'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: Text('Esplora'),
                ),
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
          onTap: () {
            _navigateTo(0);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(Icons.list),
          title: Text('Ricette'),
          selected: _selectedIndex == 1,
          onTap: () {
            _navigateTo(1);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Aggiungi'),
          selected: _selectedIndex == 2,
          onTap: () {
            _navigateTo(2);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profilo'),
          selected: _selectedIndex == 3,
          onTap: () {
            _navigateTo(3);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(Icons.explore),
          title: Text('Esplora'),
          selected: _selectedIndex == 4,
          onTap: () {
            _navigateTo(4);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(onNavigate: _navigateTo);
      case 1:
        return RecipesScreen(recipesNotifier: widget.recipesNotifier);
      case 2:
        return AddRecipeScreen(
          onAdd: (r) => widget.recipesNotifier.value = [...widget.recipesNotifier.value, r],
        );
      case 3:
        return ProfileScreen();
      case 4:
      default:
        return ExploreScreen(onNavigate: _navigateTo);
    }
  }
}