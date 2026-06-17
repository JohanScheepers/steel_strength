// lib/services/shear_service.dart

import 'package:steel_strength/models/steel_section.dart';
import 'unit_converter.dart';

/// Service for shear capacity calculations based on SANS 10162-1.
class ShearService {
  /// Calculates the shear resistance V_r (kN).
  /// Formula: V_r = φ * 0.66 * f_y * A_w
  /// where A_w = h * tw (mm²), f_y in MPa, φ dimensionless.
  static double calculateShearResistance(SteelSection section) {
    // Web area in mm²
    final double Aw = section.h * section.tw;
    // Nominal shear in N (MPa * mm² = N)
    final double nominalShear = 0.66 * section.fy * Aw;
    // Apply strength reduction factor φ and convert to kN
    final double VrN = section.phi * nominalShear;
    return UnitConverter.nToKN(VrN);
  }
}
