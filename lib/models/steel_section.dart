// lib/models/steel_section.dart
import 'package:json_annotation/json_annotation.dart';

part 'steel_section.g.dart';

@JsonSerializable()
class SteelSection {
  final String designation;
  final double h;
  final double b;
  final double tf;
  final double tw;
  final double Ix;
  final double Zx;
  final double Sx;

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

  factory SteelSection.fromJson(Map<String, dynamic> json) => _$SteelSectionFromJson(json);
  Map<String, dynamic> toJson() => _$SteelSectionToJson(this);
}
