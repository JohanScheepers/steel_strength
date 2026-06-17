// lib/services/unit_conversion.dart

/// Utility class for common unit conversions used in steel section calculations.
class UnitConversion {
  // Length conversions
  static double mmToM(double mm) => mm / 1000.0;
  static double mToMm(double m) => m * 1000.0;

  // Force conversions
  static double kNToN(double kN) => kN * 1000.0;
  static double nToKN(double n) => n / 1000.0;

  // Stress conversions
  static double mpapToPa(double mpa) => mpa * 1e6;
  static double paToMpa(double pa) => pa / 1e6;
}
