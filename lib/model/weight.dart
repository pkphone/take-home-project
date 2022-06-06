import 'package:json_annotation/json_annotation.dart';

part 'weight.g.dart';

@JsonSerializable()
class Weight {
  final double silver;
  final double gold;
  final double platinum;

  Weight(this.silver, this.gold, this.platinum);

  factory Weight.fromJson(Map<String, dynamic> json) => _$WeightFromJson(json);

  Map<String, dynamic> toJson() => _$WeightToJson(this);
}
