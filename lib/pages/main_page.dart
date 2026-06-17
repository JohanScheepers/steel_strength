// lib/pages/main_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cue/cue.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steel Strength Modules')),
      body: Cue.onMount(
        motion: .smooth(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildModuleCard(context, 'Bending Capacity', 'Calculate moment resistance', '/bending', 0),
            _buildModuleCard(context, 'Shear Capacity', 'Calculate shear resistance', '/shear', 1),
            _buildModuleCard(context, 'Axial Compression (Buckling)', 'Calculate compression resistance', '/buckling', 2),
            _buildModuleCard(context, 'Lateral-Torsional Buckling', 'Calculate reduced moment capacity', '/ltb', 3),
            _buildModuleCard(context, 'Serviceability Limit State', 'Check deflection limits', '/serviceability', 4),
            _buildModuleCard(context, 'Interaction Equations', 'Combined axial and bending check', '/interaction', 5),
            const SizedBox(height: 32),
            Actor(
              delay: 60.ms * 6,
              acts: [.fadeIn(), .slideY(from: 0.15)],
              child: ElevatedButton.icon(
                onPressed: () => context.pushNamed('settings'),
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, String subtitle, String route, int index) {
    return Actor(
      delay: 60.ms * index,
      acts: [.fadeIn(), .slideY(from: 0.15)],
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => context.push(route),
        ),
      ),
    );
  }
}
