import 'package:json_annotation/json_annotation.dart';
import 'package:take_home_project/model/slot.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  final String date;
  final List<Slot> slots;

  Data(this.date, this.slots);

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
