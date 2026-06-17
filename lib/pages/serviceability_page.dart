// lib/pages/serviceability_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/serviceability_service.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Serviceability (Deflection)')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
          const SizedBox(height: 32),
          _buildResults(),
        ],
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Results', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Text('Maximum Deflection (δ): ${defl.toStringAsFixed(2)} mm', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Live Load Limit (L/360): ${liveLimit.toStringAsFixed(2)} mm'),
            Text('Status (Live): ${liveSafe ? "Pass" : "Fail"}', 
              style: TextStyle(color: liveSafe ? Colors.green : Colors.red)),
            const SizedBox(height: 8),
            Text('Total Load Limit (L/250): ${totalLimit.toStringAsFixed(2)} mm'),
            Text('Status (Total): ${totalSafe ? "Pass" : "Fail"}', 
              style: TextStyle(color: totalSafe ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}
