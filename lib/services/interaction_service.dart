// lib/services/interaction_service.dart

/// Service for combined axial force & bending interaction check (SANS 10162‑1).
///
/// Interaction equation:
///   Cf/Cr + U1x·Mfx/Mrx + U1y·Mfy/Mry ≤ 1.0
class InteractionService {
  /// Evaluates the interaction ratio.
  ///
  /// Returns the computed ratio (must be ≤ 1.0 to pass).
  static double calculateInteractionRatio({
    required double Cf,  // Factored axial force (kN)
    required double Cr,  // Axial resistance (kN)
    required double U1x, // Amplification factor about x-axis
    required double Mfx, // Factored moment about x-axis (kNm)
    required double Mrx, // Moment resistance about x-axis (kNm)
    required double U1y, // Amplification factor about y-axis
    required double Mfy, // Factored moment about y-axis (kNm)
    required double Mry, // Moment resistance about y-axis (kNm)
  }) {
    return (Cf / Cr) + (U1x * Mfx / Mrx) + (U1y * Mfy / Mry);
  }

  /// Returns `true` when the member passes the interaction check.
  static bool passes({
    required double Cf,
    required double Cr,
    required double U1x,
    required double Mfx,
    required double Mrx,
    required double U1y,
    required double Mfy,
    required double Mry,
  }) {
    return calculateInteractionRatio(
      Cf: Cf,
      Cr: Cr,
      U1x: U1x,
      Mfx: Mfx,
      Mrx: Mrx,
      U1y: U1y,
      Mfy: Mfy,
      Mry: Mry,
    ) <= 1.0;
  }
}
