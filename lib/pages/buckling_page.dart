// lib/pages/buckling_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:cue/cue.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/buckling_service.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/utilization_gauge.dart';

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
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Axial Compression')),
        body: Cue.onMount(
          motion: .smooth(),
          child: ListView(
            padding: const EdgeInsets.all(24.0),
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
                        decoration: const InputDecoration(labelText: 'Minor-axis Inertia Iy (mm⁴)'),
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

    return Actor(
      delay: 150.ms,
      acts: [.fadeIn(), .slideY(from: 0.1)],
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Compression Resistance (Cr)', style: const TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 4),
            Text('${cr.toStringAsFixed(1)} kN', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildChip('KL: ${kl.toStringAsFixed(0)} mm'),
                _buildChip('r: ${r.toStringAsFixed(1)} mm'),
                _buildChip('λ: ${slenderness.toStringAsFixed(1)}'),
              ],
            ),
            if (cf > 0) ...[
              const SizedBox(height: 24),
              UtilizationGauge(
                utilization: util / 100.0,
                label: 'Compression Utilization',
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.white70)),
    );
  }
}
