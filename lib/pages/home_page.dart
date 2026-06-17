// lib/pages/home_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/calculator.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Reactive signals
  final selectedSectionSignal = Signal<SteelSection?>(null);
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

  void _calculate() {
    final section = selectedSectionSignal.value;
    final designMoment = designMomentSignal.value;
    if (section == null || designMoment <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a section and enter a design moment')));
      return;
    }
    final capacity = Calculator.calculateMomentResistance(section);
    final isSafe = Calculator.verifyBendingCapacity(maxAppliedMomentKnm: designMoment, resistanceKnm: capacity);
    final utilization = (designMoment / capacity) * 100;
    // Navigate to result page with arguments
    GoRouter.of(context).pushNamed('result', extra: {
      'section': section,
      'designMoment': designMoment,
      'capacity': capacity,
      'utilization': utilization,
      'isSafe': isSafe,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steel Strength Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section selector
            DropdownButtonFormField<SteelSection>(
              decoration: const InputDecoration(labelText: 'Select Steel Section'),
              items: sections.map((s) => DropdownMenuItem(value: s, child: Text(s.designation))).toList(),
              value: selectedSectionSignal.watch(context),
              onChanged: (v) => selectedSectionSignal.value = v,
            ),
            const SizedBox(height: 16),
            // Design moment input
            TextFormField(
              decoration: const InputDecoration(labelText: 'Design Ultimate Moment (kNm)'),
              keyboardType: TextInputType.number,
              onChanged: (v) => designMomentSignal.value = double.tryParse(v) ?? 0.0,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _calculate,
                child: const Text('Calculate'),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => GoRouter.of(context).pushNamed('settings'),
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
