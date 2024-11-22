class UsersWorkImg {
  // ignore: non_constant_identifier_names
  final int id_user;
  final List<String> imageUrls;

  UsersWorkImg({
    // ignore: non_constant_identifier_names
    required this.id_user,
    required this.imageUrls,
  });

  factory UsersWorkImg.fromJson(Map<String, dynamic> json) {
    return UsersWorkImg(
      id_user: json['id_user'],
      imageUrls: List<String>.from(json['imageUrls']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'imageUrls': imageUrls,
    };
  }
}