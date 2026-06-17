// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steel_section.dart';

SteelSection _$SteelSectionFromJson(Map<String, dynamic> json) => SteelSection(
      designation: json['designation'] as String,
      h: (json['h'] as num).toDouble(),
      b: (json['b'] as num).toDouble(),
      tf: (json['tf'] as num).toDouble(),
      tw: (json['tw'] as num).toDouble(),
      Ix: (json['Ix'] as num).toDouble(),
      Iy: (json['Iy'] as num).toDouble(),
      Zx: (json['Zx'] as num).toDouble(),
      Sx: (json['Sx'] as num).toDouble(),
      J: (json['J'] as num).toDouble(),
      Cw: (json['Cw'] as num).toDouble(),
      fy: (json['fy'] as num).toDouble(),
      phi: (json['phi'] as num).toDouble(),
      A: (json['A'] as num).toDouble(),
    );

Map<String, dynamic> _$SteelSectionToJson(SteelSection instance) => <String, dynamic>{
      'designation': instance.designation,
      'h': instance.h,
      'b': instance.b,
      'tf': instance.tf,
      'tw': instance.tw,
      'Ix': instance.Ix,
      'Iy': instance.Iy,
      'Zx': instance.Zx,
      'Sx': instance.Sx,
      'J': instance.J,
      'Cw': instance.Cw,
      'fy': instance.fy,
      'phi': instance.phi,
      'A': instance.A,
    };
