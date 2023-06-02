part of 'objects.dart';

@JsonSerializable(explicitToJson: true)
class VideosModel {
  final String Duration;
  final String Fee;
  final String VideoName;
  @JsonKey(name: "corse_id")
  final String corseid;
  @JsonKey(name: "course_name")
  final String coursename;
  final String id;
  final String image;
  final int status;
  final String vurl;

  VideosModel({
    required this.Duration,
    required this.Fee,
    required this.VideoName,
    required this.corseid,
    required this.coursename,
    required this.id,
    required this.image,
    required this.status,
    required this.vurl,
  });

  factory VideosModel.fromJson(Map<String, dynamic> json) =>
      _$VideosModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideosModelToJson(this);
}
