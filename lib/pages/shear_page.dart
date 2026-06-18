// lib/pages/shear_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:cue/cue.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/shear_service.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/utilization_gauge.dart';

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
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Shear Capacity')),
        body: Cue.onMount(
          motion: .smooth(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Actor(
                  acts: [.fadeIn(), .slideY(from: -0.1)],
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildResults(),
              ],
            ),
          ),
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

    return Actor(
      delay: 150.ms,
      acts: [.fadeIn(), .slideY(from: 0.1)],
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Shear Resistance (Vr)', style: const TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 4),
            Text('${vr.toStringAsFixed(1)} kN', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            if (vf > 0) ...[
              const SizedBox(height: 24),
              UtilizationGauge(
                utilization: util / 100.0,
                label: 'Shear Utilization',
              ),
            ]
          ],
        ),
      ),
    );
  }
}
