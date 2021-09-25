class SocialLinkModel {
  SocialLinkModel({
    this.id,
    this.name,
    this.type,
    this.username,
    this.url,
  });

  final String? id;
  final String? name;
  final String? type;
  final String? username;
  final String? url;

  SocialLinkModel copyWith({
    String? id,
    String? name,
    String? type,
    String? username,
    String? url,
  }) =>
      SocialLinkModel(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        username: username ?? this.username,
        url: url ?? this.url,
      );

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) =>
      SocialLinkModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        username: json["username"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "username": username,
        "url": url,
      };
}
