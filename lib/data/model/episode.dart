class Episode {
  Episode({
    required this.name,
  });

  final String name;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
