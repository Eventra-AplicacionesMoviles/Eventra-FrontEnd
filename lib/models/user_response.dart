class UserResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String url;
  final SimpleTypeOfUserResponse typeOfUser;

  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.url,
    required this.typeOfUser,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      url: json['url'] ?? '',
      typeOfUser: SimpleTypeOfUserResponse.fromJson(json['typeOfUser'] ?? {}),
    );
  }
}

class SimpleTypeOfUserResponse {
  final int typeId;
  final String description;

  SimpleTypeOfUserResponse({
    required this.typeId,
    required this.description,
  });

  factory SimpleTypeOfUserResponse.fromJson(Map<String, dynamic> json) {
    return SimpleTypeOfUserResponse(
      typeId: json['typeId'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}