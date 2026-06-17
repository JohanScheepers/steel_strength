// lib/pages/serviceability_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:cue/cue.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/serviceability_service.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/utilization_gauge.dart';

class ServiceabilityPage extends StatefulWidget {
  const ServiceabilityPage({Key? key}) : super(key: key);

  @override
  State<ServiceabilityPage> createState() => _ServiceabilityPageState();
}

class _ServiceabilityPageState extends State<ServiceabilityPage> {
  final selectedSectionSignal = Signal<SteelSection?>(null);
  final spanSignal = Signal<double>(5000.0);
  final loadSignal = Signal<double>(5.0);

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
        appBar: AppBar(title: const Text('Serviceability (Deflection)')),
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
                        onChanged: (v) => selectedSectionSignal.value = v,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Span Length (mm)'),
                        keyboardType: TextInputType.number,
                        initialValue: '5000',
                        onChanged: (v) => spanSignal.value = double.tryParse(v) ?? 0.0,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Uniformly Distributed Load (kN/m)'),
                        keyboardType: TextInputType.number,
                        initialValue: '5',
                        onChanged: (v) => loadSignal.value = double.tryParse(v) ?? 0.0,
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
    final span = spanSignal.watch(context);
    final load = loadSignal.watch(context);
    
    if (section == null || span <= 0) return const SizedBox.shrink();

    final defl = ServiceabilityService.deflectionUDL(
      loadKnPerM: load, spanMm: span, Ix: section.Ix
    );
    final liveLimit = ServiceabilityService.liveLoadLimit(span);
    final totalLimit = ServiceabilityService.totalLoadLimit(span);
    
    final liveSafe = ServiceabilityService.passesLiveLoad(deflectionMm: defl, spanMm: span);
    final totalSafe = ServiceabilityService.passesTotalLoad(deflectionMm: defl, spanMm: span);

    final util = defl / liveLimit;

    return Actor(
      delay: 150.ms,
      acts: [.fadeIn(), .slideY(from: 0.1)],
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Maximum Deflection (δ)', style: const TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 4),
            Text('${defl.toStringAsFixed(2)} mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildChip('Live Limit: ${liveLimit.toStringAsFixed(1)} mm', liveSafe),
                _buildChip('Total Limit: ${totalLimit.toStringAsFixed(1)} mm', totalSafe),
              ],
            ),
            if (load > 0) ...[
              const SizedBox(height: 24),
              UtilizationGauge(
                utilization: util,
                label: 'Deflection Utilization',
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text, bool isSafe) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSafe ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSafe ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3)),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: isSafe ? Colors.greenAccent : Colors.redAccent)),
    );
  }
}
