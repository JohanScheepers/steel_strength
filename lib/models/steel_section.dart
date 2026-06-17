// lib/models/steel_section.dart
import 'package:json_annotation/json_annotation.dart';

part 'steel_section.g.dart';

@JsonSerializable()
class SteelSection {
  final String designation;
  final double h; // total depth (mm)
  final double b; // flange width (mm)
  final double tf; // flange thickness (mm)
  final double tw; // web thickness (mm)
  final double Ix; // major axis moment of area (mm^4)
  final double Iy; // minor axis moment of area (mm^4)
  final double Zx; // plastic section modulus (mm^3)
  final double Sx; // elastic section modulus (mm^3)
  final double J; // St. Venant torsion constant (mm^4)
  final double Cw; // Warping torsion constant (mm^6)
  final double fy; // yield stress (MPa)
  final double phi; // strength reduction factor (dimensionless)
  final double A; // cross‑sectional area (mm^2)

  const SteelSection({
    required this.designation,
    required this.h,
    required this.b,
    required this.tf,
    required this.tw,
    required this.Ix,
    required this.Iy,
    required this.Zx,
    required this.Sx,
    required this.J,
    required this.Cw,
    required this.fy,
    required this.phi,
    required this.A,
  });

  factory SteelSection.fromJson(Map<String, dynamic> json) => _$SteelSectionFromJson(json);
  Map<String, dynamic> toJson() => _$SteelSectionToJson(this);
}
