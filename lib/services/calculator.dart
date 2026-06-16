// lib/services/calculator.dart
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/data/sans_steel_engine.dart';

class Calculator {
  /// Wrapper around SansSteelEngine to calculate factored moment resistance.
  static double calculateMomentResistance(SteelSection section) {
    return SansSteelEngine.calculateMomentResistance(section);
  }

  /// Verify bending capacity using SansSteelEngine logic.
  static bool verifyBendingCapacity({
    required double maxAppliedMomentKnm,
    required double resistanceKnm,
  }) {
    return SansSteelEngine.verifyBendingCapacity(
      maxAppliedMomentKnm: maxAppliedMomentKnm,
      resistanceKnm: resistanceKnm,
    );
  }
}
