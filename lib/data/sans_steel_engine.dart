import 'package:steel_strength/models/steel_section.dart';

class SansSteelEngine {
  // SANS 10162-1 structural steel capacity reduction factor
  static const double phi = 0.90;

  // Standard South African steel grade yield strength (S355JR)
  // Note: For plates/flanges > 16mm, fy drops to 345 MPa, but 355 MPa is standard.
  static const double fy = 355.0; // N/mm^2 (MPa)

  /// Calculates the Factored Moment Resistance (Mr) in kNm
  static double calculateMomentResistance(SteelSection section) {
    // Equation: Mr = phi * fy * Sx
    // Sx is in mm^3, fy is in N/mm^2 -> Result is in N*mm.
    // Divide by 1,000,000 to convert N*mm to kNm (Kilonewton-meters).
    double nominalMoment = fy * section.Sx;
    double factoredMoment = phi * nominalMoment;

    return factoredMoment / 1e6;
  }

  /// Evaluates if the beam passes the Ultimate Limit State (ULS) for bending
  static bool verifyBendingCapacity({
    required double maxAppliedMomentKnm,
    required double resistanceKnm,
  }) {
    return resistanceKnm >= maxAppliedMomentKnm;
  }
}
