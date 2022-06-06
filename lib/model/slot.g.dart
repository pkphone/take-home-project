// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slot _$SlotFromJson(Map<String, dynamic> json) => Slot(
      json['start_time'] as String,
      json['end_time'] as String,
      json['available'] as bool,
    );

Map<String, dynamic> _$SlotToJson(Slot instance) => <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'available': instance.available,
    };
