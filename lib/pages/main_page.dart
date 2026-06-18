// lib/pages/main_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Steel Strength Modules')),
        body: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
              _buildModuleCard(context, 'Bending Capacity', 'Calculate moment resistance', '/bending', 0, Icons.architecture),
              const SizedBox(height: 12),
              _buildModuleCard(context, 'Shear Capacity', 'Calculate shear resistance', '/shear', 1, Icons.content_cut),
              const SizedBox(height: 12),
              _buildModuleCard(context, 'Axial Compression (Buckling)', 'Calculate compression resistance', '/buckling', 2, Icons.compress),
              const SizedBox(height: 12),
              _buildModuleCard(context, 'Lateral-Torsional Buckling', 'Calculate reduced moment capacity', '/ltb', 3, Icons.rotate_right),
              const SizedBox(height: 12),
              _buildModuleCard(context, 'Serviceability Limit State', 'Check deflection limits', '/serviceability', 4, Icons.straighten),
              const SizedBox(height: 12),
              _buildModuleCard(context, 'Interaction Equations', 'Combined axial and bending check', '/interaction', 5, Icons.compare_arrows),
              const SizedBox(height: 32),
            GlassCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.settings, color: Colors.white70),
                title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                onTap: () => context.push('/settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, String subtitle, String route, int index, IconData icon) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: () => context.push(route),
      ),
    );
  }
}
