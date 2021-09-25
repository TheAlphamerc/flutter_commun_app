import 'dart:convert';

class CoverImage {
  CoverImage({
    this.id,
    this.path,
    this.createdAt,
    this.modifyAt,
  });

  final String? id;
  final String? path;
  final String? createdAt;
  final String? modifyAt;

  CoverImage copyWith({
    String? id,
    String? path,
    String? createdAt,
    String? modifyAt,
  }) =>
      CoverImage(
        id: id ?? this.id,
        path: path ?? this.path,
        createdAt: createdAt ?? this.createdAt,
        modifyAt: modifyAt ?? this.modifyAt,
      );

  String toRawJson() => json.encode(toJson());

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
        id: json["id"],
        path: json["path"],
        createdAt: json["createdAt"],
        modifyAt: json["modifyAt"],
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "path": path, "createdAt": createdAt, "modifyAt": modifyAt};
}
