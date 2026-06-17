// lib/services/serviceability_service.dart

/// Service for Serviceability Limit State (SLS) deflection checks
/// as per SANS 10160.
class ServiceabilityService {
  /// Live‑load deflection limit: L / 360.
  static double liveLoadLimit(double spanMm) => spanMm / 360.0;

  /// Total‑load deflection limit: L / 250.
  static double totalLoadLimit(double spanMm) => spanMm / 250.0;

  /// Maximum mid‑span deflection for a simply‑supported beam with
  /// a uniformly distributed load (UDL).
  ///
  /// δ = 5 w L⁴ / (384 E I)
  ///
  /// Parameters:
  ///   - [loadKnPerM] uniformly distributed load in kN/m
  ///   - [spanMm]     span in mm
  ///   - [Ix]         moment of inertia in mm⁴
  ///   - [E]          Young's modulus (default 200 000 MPa)
  ///
  /// Returns the deflection in mm.
  static double deflectionUDL({
    required double loadKnPerM,
    required double spanMm,
    required double Ix,
    double E = 200000.0,
  }) {
    // Convert load from kN/m to N/mm  (1 kN/m = 1 N/mm)
    final double w = loadKnPerM; // N/mm
    final double L = spanMm;
    return (5.0 * w * L * L * L * L) / (384.0 * E * Ix);
  }

  /// Checks whether the computed deflection passes the live‑load limit.
  static bool passesLiveLoad({
    required double deflectionMm,
    required double spanMm,
  }) {
    return deflectionMm <= liveLoadLimit(spanMm);
  }

  /// Checks whether the computed deflection passes the total‑load limit.
  static bool passesTotalLoad({
    required double deflectionMm,
    required double spanMm,
  }) {
    return deflectionMm <= totalLoadLimit(spanMm);
  }
}
