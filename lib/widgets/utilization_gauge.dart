import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/color_palette.dart';
import 'dart:math';

class UtilizationGauge extends StatelessWidget {
  final double utilization; // 0.0 to 1.0 (or higher)
  final String label;

  const UtilizationGauge({
    Key? key,
    required this.utilization,
    this.label = 'Utilization',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Clamp visualization to 1.0 (100%), but allow text to show > 100%
    final double visualValue = utilization > 1.0 ? 1.0 : utilization;
    final double displayUtil = max(0.0, min(1.0, utilization));

    Color gaugeColor;
    if (utilization < 0.8) {
      gaugeColor = AppColors.gaugeSafe;
    } else if (utilization <= 1.0) {
      gaugeColor = AppColors.gaugeWarning;
    } else {
      gaugeColor = AppColors.gaugeCritical;
    }

    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              centerSpaceRadius: 60,
              sectionsSpace: 0,
              sections: [
                PieChartSectionData(
                  color: gaugeColor,
                  value: visualValue * 100,
                  title: '',
                  radius: 20,
                  badgeWidget: _buildGlowBadge(gaugeColor),
                  badgePositionPercentageOffset: 1.0,
                ),
                PieChartSectionData(
                  color: Colors.white.withValues(alpha: 0.1),
                  value: max(0.0, 1.0 - displayUtil) * 100,
                  title: '',
                  radius: 20,
                ),
              ],
            ),
            swapAnimationDuration: const Duration(milliseconds: 1500),
            swapAnimationCurve: Curves.easeOutCubic,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(utilization * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: gaugeColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurface,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlowBadge(Color color) {
    return Container(
      width: 4,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.8),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
