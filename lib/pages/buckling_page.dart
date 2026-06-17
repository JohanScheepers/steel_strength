// lib/pages/buckling_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/buckling_service.dart';

class BucklingPage extends StatefulWidget {
  const BucklingPage({Key? key}) : super(key: key);

  @override
  State<BucklingPage> createState() => _BucklingPageState();
}

class _BucklingPageState extends State<BucklingPage> {
  final selectedSectionSignal = Signal<SteelSection?>(null);
  final kFactorSignal = Signal<double>(1.0);
  final lengthSignal = Signal<double>(3000.0);
  final designAxialSignal = Signal<double>(0.0);
  final customIySignal = Signal<double>(1000000.0); // Dummy default for Iy

  List<SteelSection> sections = [];

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    final data = await rootBundle.loadString('assets/steel_sections.json');
    final List<dynamic> jsonList = jsonDecode(data);
    setState(() {
      sections = jsonList.map((e) => SteelSection.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Axial Compression')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          DropdownButtonFormField<SteelSection>(
            decoration: const InputDecoration(labelText: 'Select Steel Section'),
            items: sections.map((s) => DropdownMenuItem(value: s, child: Text(s.designation))).toList(),
            value: selectedSectionSignal.watch(context),
            onChanged: (v) {
              selectedSectionSignal.value = v;
              if (v != null) {
                customIySignal.value = v.Iy;
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Effective Length Factor (K)'),
            keyboardType: TextInputType.number,
            initialValue: '1.0',
            onChanged: (v) => kFactorSignal.value = double.tryParse(v) ?? 1.0,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Physical Length L (mm)'),
            keyboardType: TextInputType.number,
            initialValue: '3000',
            onChanged: (v) => lengthSignal.value = double.tryParse(v) ?? 0.0,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Minor-axis Inertia Iy (mm⁴) [Not in DB]'),
            keyboardType: TextInputType.number,
            initialValue: customIySignal.value.toString(),
            key: ValueKey(customIySignal.value),
            onChanged: (v) => customIySignal.value = double.tryParse(v) ?? 1000000.0,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Design Axial Force Cf (kN)'),
            keyboardType: TextInputType.number,
            onChanged: (v) => designAxialSignal.value = double.tryParse(v) ?? 0.0,
          ),
          const SizedBox(height: 32),
          _buildResults(),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final section = selectedSectionSignal.watch(context);
    final cf = designAxialSignal.watch(context);
    final k = kFactorSignal.watch(context);
    final l = lengthSignal.watch(context);
    final iy = customIySignal.watch(context);
    
    if (section == null) return const SizedBox.shrink();

    final kl = BucklingService.calculateEffectiveLength(length: l, kFactor: k);
    final r = BucklingService.calculateRadiusOfGyration(I: iy, A: section.A);
    final slenderness = r > 0 ? BucklingService.calculateSlenderness(effectiveLength: kl, radiusGyration: r) : 0.0;
    
    final cr = BucklingService.calculateCompressionResistance(section, slenderness);
    final util = cf > 0 ? (cf / cr) * 100 : 0.0;
    final isSafe = cf <= cr;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Results', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Text('Effective Length (KL): ${kl.toStringAsFixed(1)} mm'),
            Text('Radius of Gyration (r): ${r.toStringAsFixed(2)} mm'),
            Text('Slenderness Ratio (λ): ${slenderness.toStringAsFixed(2)}'),
            Text('Compression Resistance (Cr): ${cr.toStringAsFixed(2)} kN', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (cf > 0) ...[
              Text('Utilization: ${util.toStringAsFixed(1)}%'),
              Text('Status: ${isSafe ? "Safe" : "Unsafe"}', 
                style: TextStyle(color: isSafe ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
    );
  }
}
