// lib/services/ltb_service.dart

import 'dart:math' as math;
import 'package:steel_strength/models/steel_section.dart';
import 'package:steel_strength/services/unit_converter.dart';

/// Service for Lateral-Torsional Buckling calculations (SANS 10162‑1).
class LtbService {
  /// Calculates the critical elastic buckling moment Mu (kNm).
  ///
  /// Simplified formula for doubly-symmetric I-sections:
  ///   Mu = (π / Lu) * √(E * Iy * G * J + (π * E / Lu)² * Iy * Cw)
  ///
  /// Parameters:
  ///   - [unsupportedLength] Lu in mm
  ///   - [E]  Young's modulus (default 200 000 MPa)
  ///   - [G]  Shear modulus   (default  77 000 MPa)
  ///   - [Iy] Minor‑axis moment of inertia (mm⁴)
  ///   - [J]  St. Venant torsion constant (mm⁴)
  ///   - [Cw] Warping torsion constant (mm⁶)
  static double calculateCriticalMoment({
    required double unsupportedLength,
    required double Iy,
    required double J,
    required double Cw,
    double E = 200000.0,
    double G = 77000.0,
  }) {
    final double Lu = unsupportedLength;
    final double piOverLu = math.pi / Lu;
    final double term1 = E * Iy * G * J;
    final double term2 = math.pow(math.pi * E / Lu, 2).toDouble() * Iy * Cw;
    // Mu in N·mm
    final double Mu = piOverLu * math.sqrt(term1 + term2);
    // Convert to kNm (N·mm → kNm = /1e6)
    return Mu / 1e6;
  }

  /// Calculates the reduced moment capacity Mr' (kNm) due to LTB.
  ///
  /// Uses the SANS 10162-1 curve:
  ///   If Mu >= 0.67 * Mp:
  ///     Mr' = φ * 1.15 * Mp * (1 - 0.28 * Mp / Mu)   (capped at φ * Mp)
  ///   Else:
  ///     Mr' = φ * Mu
  static double calculateReducedMoment({
    required SteelSection section,
    required double Mu,
  }) {
    // Plastic moment Mp = fy * Zx / 1e6 (kNm)
    final double Mp = section.fy * section.Zx / 1e6;
    final double phi = section.phi;

    if (Mu >= 0.67 * Mp) {
      final double reduced = 1.15 * Mp * (1.0 - 0.28 * Mp / Mu);
      return phi * math.min(reduced, Mp);
    } else {
      return phi * Mu;
    }
  }
}
