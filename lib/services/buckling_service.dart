// lib/services/buckling_service.dart

import 'dart:math' as math;
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/unit_converter.dart';

/// Service for axial compression / column buckling calculations (SANS 10162‑1).
class BucklingService {
  static const double _n = 1.34; // exponent for hot‑rolled sections

  /// Effective length (KL) = K * L.
  static double calculateEffectiveLength({required double length, required double kFactor}) {
    return length * kFactor;
  }

  /// Radius of gyration r = sqrt(I / A).
  static double calculateRadiusOfGyration({required double I, required double A}) {
    return math.sqrt(I / A);
  }

  /// Slenderness ratio λ = (KL) / r.
  static double calculateSlenderness({required double effectiveLength, required double radiusGyration}) {
    return effectiveLength / radiusGyration;
  }

  /// Compression resistance C_r (kN).
  /// Formula: C_r = φ * A * f_y * (1 + λ^{2n})^{-1/n}
  /// A is mm², f_y is MPa (N/mm²) => N, then converted to kN.
  static double calculateCompressionResistance(
    SteelSection section,
    double slenderness,
  ) {
    final double numerator = 1 + (math.pow(slenderness, 2 * _n) as double);
    final double factor = (math.pow(numerator, -1 / _n) as double);
    final double nominal = section.A * section.fy * factor; // N
    final double phiNominal = section.phi * nominal; // N
    return UnitConverter.nToKN(phiNominal);
  }
}
