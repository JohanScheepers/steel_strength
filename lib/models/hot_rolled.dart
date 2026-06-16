/// Represents a structural steel section based on the SAISC Red Book.
class SteelSection {
  final String designation; // e.g., "IPE 200" or "203x133x30 UB"
  final double h; // Total depth (mm)
  final double b; // Flange width (mm)
  final double tf; // Flange thickness (mm)
  final double tw; // Web thickness (mm)
  final double Ix; // Major axis Moment of Inertia (mm^4)
  final double Zx; // Elastic Section Modulus (mm^3)
  final double Sx; // Plastic Section Modulus (mm^3)

  const SteelSection({
    required this.designation,
    required this.h,
    required this.b,
    required this.tf,
    required this.tw,
    required this.Ix,
    required this.Zx,
    required this.Sx,
  });
}
