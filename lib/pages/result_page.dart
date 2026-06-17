// lib/pages/result_page.dart
import 'package:flutter/material.dart';
import 'package:cue/cue.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/pdf_report.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/utilization_gauge.dart';


class ResultPage extends StatelessWidget {
  final SteelSection? section;
  final double? designMoment;
  final double? capacity;
  final double? utilization;
  final bool? isSafe;

  const ResultPage({
    Key? key,
    this.section,
    this.designMoment,
    this.capacity,
    this.utilization,
    this.isSafe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (section == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: const Center(child: Text('No data')),
      );
    }
    final util = utilization ?? 0;
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Bending Result')),
        body: Cue.onMount(
          motion: .smooth(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Actor(
                  acts: [.fadeIn(), .slideY(from: 0.1)],
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          section!.designation,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatValue('Design Moment', '${designMoment?.toStringAsFixed(1)} kNm'),
                            _buildStatValue('Capacity', '${capacity?.toStringAsFixed(1)} kNm'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Actor(
                  delay: 150.ms,
                  acts: [.fadeIn(), .scale(from: 0.9)],
                  child: GlassCard(
                    child: UtilizationGauge(
                      utilization: util / 100.0,
                      label: 'Bending Utilization',
                    ),
                  ),
                ),
                const Spacer(),
                Actor(
                  delay: 300.ms,
                  acts: [.fadeIn(), .slideY(from: 0.1)],
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final pdfFile = await PdfReportService.generatePdf(
                        section: section!,
                        designMoment: designMoment!,
                        capacity: capacity!,
                        utilization: util,
                        isSafe: isSafe ?? false,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved: $pdfFile')));
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Export PDF Report', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatValue(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ],
    );
  }
}
