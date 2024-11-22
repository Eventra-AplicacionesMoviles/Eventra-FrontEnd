class UserRequest {
  final String firstName;
  final String lastName;
  final String email;
  final int typeId;
  final String? url;

  UserRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.typeId,
    this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'typeId': typeId,
      'url': url,
    };
  }
}