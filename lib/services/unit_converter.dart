// lib/services/unit_converter.dart

/// Helper class for converting between common engineering units.
class UnitConverter {
  /// Convert millimetres to metres.
  static double mmToM(double mm) => mm / 1000.0;

  /// Convert metres to millimetres.
  static double mToMm(double m) => m * 1000.0;

  /// Convert kilonewtons to newtons.
  static double kNToN(double kN) => kN * 1000.0;

  /// Convert newtons to kilonewtons.
  static double nToKN(double n) => n / 1000.0;
}
