class PostModel {
  int id;
  String title;
  String description;
  String subtitle;
  String imgUrl;
  int employerId;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subtitle,
    required this.imgUrl,
    required this.employerId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        subtitle: json['subtitle'],
        imgUrl: json['imgUrl'],
        employerId: json['employerId']
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subtitle': subtitle,
      'imgUrl': imgUrl,
      'employerId': employerId
    };
  }
}
