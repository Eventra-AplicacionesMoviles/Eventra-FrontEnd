class Organizer {
  final int id;
  final String firstName;
  final String lastName;

  Organizer({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['userId'] ?? 0, // Provide a default value of 0 if null
      firstName: json['firstName'] ?? '', // Provide a default value of empty string if null
      lastName: json['lastName'] ?? '', // Provide a default value of empty string if null
    );
  }
}