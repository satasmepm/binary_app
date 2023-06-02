part of 'objects.dart';

@JsonSerializable(explicitToJson: true)
class ZomLinkModel {
  final String group_id;
  final List zoom_links;

  ZomLinkModel({
    required this.group_id,
    required this.zoom_links,
  });

  factory ZomLinkModel.fromJson(Map<String, dynamic> json) =>
      _$ZomLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZomLinkModelToJson(this);
}
