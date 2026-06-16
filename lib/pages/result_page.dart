// lib/pages/result_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/pdf_report.dart';
import 'package:steel_strength/router.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Section: ${section!.designation}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Design Moment: ${designMoment?.toStringAsFixed(2)} kNm'),
            Text('Capacity: ${capacity?.toStringAsFixed(2)} kNm'),
            Text('Utilization: ${util.toStringAsFixed(1)}%'),
            Text('Status: ${isSafe == true ? "Safe" : "Unsafe"}', style: TextStyle(color: isSafe == true ? Colors.green : Colors.red)),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 20)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text('Utilization');
                      return const SizedBox.shrink();
                    })),
                  ),
                  barGroups: <BarChartGroupData>[
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: util, width: 30, color: isSafe == true ? Colors.green : Colors.red)])
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
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
                label: const Text('Export PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
