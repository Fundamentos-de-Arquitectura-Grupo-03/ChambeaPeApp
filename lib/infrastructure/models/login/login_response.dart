class LoginResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime birthdate;
  final String gender;
  final String profilePic;
  final String description;
  final String userRole;
  final int hasPremium;

  LoginResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.birthdate,
    required this.gender,
    required this.profilePic,
    required this.description,
    required this.userRole,
    this.hasPremium = 0,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        birthdate: DateTime.parse(json["birthdate"]),
        gender: json["gender"],
        profilePic: json["profilePic"],
        description: json["description"],
        userRole: json["userRole"],
        hasPremium: json["hasPremium"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "birthdate": birthdate.toIso8601String(),
        "gender": gender,
        "profilePic": profilePic,
        "description": description,
        "userRole": userRole,
        "hasPremium": hasPremium,
      };
}
