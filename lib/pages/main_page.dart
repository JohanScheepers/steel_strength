// lib/pages/main_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steel Strength Modules')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildModuleCard(context, 'Bending Capacity', 'Calculate moment resistance', '/bending'),
          _buildModuleCard(context, 'Shear Capacity', 'Calculate shear resistance', '/shear'),
          _buildModuleCard(context, 'Axial Compression (Buckling)', 'Calculate compression resistance', '/buckling'),
          _buildModuleCard(context, 'Lateral-Torsional Buckling', 'Calculate reduced moment capacity', '/ltb'),
          _buildModuleCard(context, 'Serviceability Limit State', 'Check deflection limits', '/serviceability'),
          _buildModuleCard(context, 'Interaction Equations', 'Combined axial and bending check', '/interaction'),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.pushNamed('settings'),
            icon: const Icon(Icons.settings),
            label: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, String subtitle, String route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => context.push(route),
      ),
    );
  }
}
