part of 'objects.dart';

@JsonSerializable(explicitToJson: true)
class UserZoomLinkModel {
  final String course_pay_id;
  final String group_id;
  final String group_image;
  final String group_name;
  final String use_id;
  final List zoom_links;
  final String zoom_links_id;

  UserZoomLinkModel({
    required this.course_pay_id,
    required this.group_id,
    required this.group_image,
    required this.group_name,
    required this.use_id,
    required this.zoom_links,
    required this.zoom_links_id,
  });

  factory UserZoomLinkModel.fromJson(Map<String, dynamic> json) =>
      _$UserZoomLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserZoomLinkModelToJson(this);
}
