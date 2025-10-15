import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

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
                  onPressed: () => onNavigate(1),
                ),
                OutlinedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Aggiungi Ricetta'),
                  onPressed: () => onNavigate(2),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}