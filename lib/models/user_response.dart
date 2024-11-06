class UserResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final SimpleTypeOfUserResponse typeOfUser;

  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.typeOfUser,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      typeOfUser: SimpleTypeOfUserResponse.fromJson(json['typeOfUser']),
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
      typeId: json['typeId'],
      description: json['description'],
    );
  }
}