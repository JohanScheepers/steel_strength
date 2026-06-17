// lib/pages/ltb_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:cue/cue.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/ltb_service.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/utilization_gauge.dart';

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
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Lateral-Torsional Buckling')),
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

    return Actor(
      delay: 150.ms,
      acts: [.fadeIn(), .slideY(from: 0.1)],
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Reduced Moment Capacity (Mr\')', style: const TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 4),
            Text('${mr.toStringAsFixed(1)} kNm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildChip('Mu: ${mu.toStringAsFixed(1)} kNm'),
              ],
            ),
            if (mf > 0) ...[
              const SizedBox(height: 24),
              UtilizationGauge(
                utilization: util / 100.0,
                label: 'LTB Utilization',
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
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.white70)),
    );
  }
}
