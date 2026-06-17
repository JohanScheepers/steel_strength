// lib/pages/ltb_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/ltb_service.dart';

class LtbPage extends StatefulWidget {
  const LtbPage({Key? key}) : super(key: key);

  @override
  State<LtbPage> createState() => _LtbPageState();
}

class _LtbPageState extends State<LtbPage> {
  final selectedSectionSignal = Signal<SteelSection?>(null);
  final luSignal = Signal<double>(2000.0);
  final customIySignal = Signal<double>(1000000.0);
  final customJSignal = Signal<double>(150000.0);
  final customCwSignal = Signal<double>(50000000000.0);
  final designMomentSignal = Signal<double>(0.0);

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
      appBar: AppBar(title: const Text('Lateral-Torsional Buckling')),
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
                customJSignal.value = v.J;
                customCwSignal.value = v.Cw;
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Unsupported Length Lu (mm)'),
            keyboardType: TextInputType.number,
            initialValue: '2000',
            onChanged: (v) => luSignal.value = double.tryParse(v) ?? 0.0,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Minor-axis Inertia Iy (mm⁴)'),
            keyboardType: TextInputType.number,
            initialValue: customIySignal.value.toString(),
            key: ValueKey('Iy_${customIySignal.value}'),
            onChanged: (v) => customIySignal.value = double.tryParse(v) ?? 1000000.0,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'St. Venant Torsion J (mm⁴)'),
            keyboardType: TextInputType.number,
            initialValue: customJSignal.value.toString(),
            key: ValueKey('J_${customJSignal.value}'),
            onChanged: (v) => customJSignal.value = double.tryParse(v) ?? 150000.0,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Warping Constant Cw (mm⁶)'),
            keyboardType: TextInputType.number,
            initialValue: customCwSignal.value.toString(),
            key: ValueKey('Cw_${customCwSignal.value}'),
            onChanged: (v) => customCwSignal.value = double.tryParse(v) ?? 50000000000.0,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Design Moment Mf (kNm)'),
            keyboardType: TextInputType.number,
            onChanged: (v) => designMomentSignal.value = double.tryParse(v) ?? 0.0,
          ),
          const SizedBox(height: 32),
          _buildResults(),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final section = selectedSectionSignal.watch(context);
    final lu = luSignal.watch(context);
    final iy = customIySignal.watch(context);
    final j = customJSignal.watch(context);
    final cw = customCwSignal.watch(context);
    final mf = designMomentSignal.watch(context);
    
    if (section == null || lu <= 0) return const SizedBox.shrink();

    final mu = LtbService.calculateCriticalMoment(
      unsupportedLength: lu, Iy: iy, J: j, Cw: cw
    );
    final mr = LtbService.calculateReducedMoment(section: section, Mu: mu);
    final util = mf > 0 ? (mf / mr) * 100 : 0.0;
    final isSafe = mf <= mr;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Results', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Text('Critical Elastic Moment (Mu): ${mu.toStringAsFixed(2)} kNm'),
            Text('Reduced Moment Capacity (Mr\'): ${mr.toStringAsFixed(2)} kNm', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (mf > 0) ...[
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
