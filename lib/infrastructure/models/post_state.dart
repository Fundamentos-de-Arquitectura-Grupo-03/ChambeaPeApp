class PostState {
  final int id;
  final String title;
  final String description;
  final String subtitle;
  final String imgUrl;
  final int employerId;

  PostState({
    required this.id,
    required this.title,
    required this.description,
    required this.subtitle,
    required this.imgUrl,
    required this.employerId,
  });

  factory PostState.fromJson(Map<String, dynamic> json) => PostState(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        subtitle: json["subtitle"],
        imgUrl: json["imgUrl"],
        employerId: json["employerId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "subtitle": subtitle,
        "imgUrl": imgUrl,
        "employerId": employerId,
      };
}
