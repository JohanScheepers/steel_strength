// lib/pages/interaction_page.dart
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:steel_strength/services/interaction_service.dart';

class InteractionPage extends StatefulWidget {
  const InteractionPage({Key? key}) : super(key: key);

  @override
  State<InteractionPage> createState() => _InteractionPageState();
}

class _InteractionPageState extends State<InteractionPage> {
  final cfSignal = Signal<double>(0.0);
  final crSignal = Signal<double>(100.0);
  
  final mfxSignal = Signal<double>(0.0);
  final mrxSignal = Signal<double>(100.0);
  final u1xSignal = Signal<double>(1.0);
  
  final mfySignal = Signal<double>(0.0);
  final mrySignal = Signal<double>(100.0);
  final u1ySignal = Signal<double>(1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interaction Equations')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Axial Forces (kN)', style: TextStyle(fontWeight: FontWeight.bold)),
          _buildField('Design Axial Force (Cf)', cfSignal),
          _buildField('Axial Resistance (Cr)', crSignal),
          const Divider(),
          
          const Text('X-Axis Bending (kNm)', style: TextStyle(fontWeight: FontWeight.bold)),
          _buildField('Design Moment X (Mfx)', mfxSignal),
          _buildField('Moment Resistance X (Mrx)', mrxSignal),
          _buildField('Amplification Factor (U1x)', u1xSignal),
          const Divider(),
          
          const Text('Y-Axis Bending (kNm)', style: TextStyle(fontWeight: FontWeight.bold)),
          _buildField('Design Moment Y (Mfy)', mfySignal),
          _buildField('Moment Resistance Y (Mry)', mrySignal),
          _buildField('Amplification Factor (U1y)', u1ySignal),
          const SizedBox(height: 32),
          
          _buildResults(),
        ],
      ),
    );
  }

  Widget _buildField(String label, Signal<double> signal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: TextInputType.number,
        initialValue: signal.value.toString(),
        onChanged: (v) => signal.value = double.tryParse(v) ?? 0.0,
      ),
    );
  }

  Widget _buildResults() {
    final cf = cfSignal.watch(context);
    final cr = crSignal.watch(context);
    final mfx = mfxSignal.watch(context);
    final mrx = mrxSignal.watch(context);
    final u1x = u1xSignal.watch(context);
    final mfy = mfySignal.watch(context);
    final mry = mrySignal.watch(context);
    final u1y = u1ySignal.watch(context);

    if (cr <= 0 || mrx <= 0 || mry <= 0) {
      return const Text('Resistance values must be greater than zero.', style: TextStyle(color: Colors.red));
    }

    final ratio = InteractionService.calculateInteractionRatio(
      Cf: cf, Cr: cr, U1x: u1x, Mfx: mfx, Mrx: mrx, U1y: u1y, Mfy: mfy, Mry: mry
    );
    final passes = ratio <= 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Interaction Results', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Text('Interaction Ratio: ${ratio.toStringAsFixed(3)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Target: ≤ 1.0'),
            const SizedBox(height: 8),
            Text('Status: ${passes ? "Pass" : "Fail"}', 
              style: TextStyle(color: passes ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
