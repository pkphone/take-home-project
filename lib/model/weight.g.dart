// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weight _$WeightFromJson(Map<String, dynamic> json) => Weight(
      (json['silver'] as num).toDouble(),
      (json['gold'] as num).toDouble(),
      (json['platinum'] as num).toDouble(),
    );

Map<String, dynamic> _$WeightToJson(Weight instance) => <String, dynamic>{
      'silver': instance.silver,
      'gold': instance.gold,
      'platinum': instance.platinum,
    };
