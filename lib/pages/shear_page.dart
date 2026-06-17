// lib/pages/shear_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/shear_service.dart';

class ShearPage extends StatefulWidget {
  const ShearPage({Key? key}) : super(key: key);

  @override
  State<ShearPage> createState() => _ShearPageState();
}

class _ShearPageState extends State<ShearPage> {
  final selectedSectionSignal = Signal<SteelSection?>(null);
  final designShearSignal = Signal<double>(0.0);
  
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
      appBar: AppBar(title: const Text('Shear Capacity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<SteelSection>(
              decoration: const InputDecoration(labelText: 'Select Steel Section'),
              items: sections.map((s) => DropdownMenuItem(value: s, child: Text(s.designation))).toList(),
              value: selectedSectionSignal.watch(context),
              onChanged: (v) => selectedSectionSignal.value = v,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Design Shear Force Vf (kN)'),
              keyboardType: TextInputType.number,
              onChanged: (v) => designShearSignal.value = double.tryParse(v) ?? 0.0,
            ),
            const SizedBox(height: 32),
            _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final section = selectedSectionSignal.watch(context);
    final vf = designShearSignal.watch(context);
    
    if (section == null) return const SizedBox.shrink();

    final vr = ShearService.calculateShearResistance(section);
    final util = vf > 0 ? (vf / vr) * 100 : 0.0;
    final isSafe = vf <= vr;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Results', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Text('Web Area (Aw): ${(section.h * section.tw).toStringAsFixed(1)} mm²'),
            Text('Shear Resistance (Vr): ${vr.toStringAsFixed(2)} kN', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (vf > 0) ...[
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
