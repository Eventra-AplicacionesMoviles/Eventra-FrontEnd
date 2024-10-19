
class EventResponse {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final Organizer organizer;
  final CategoryEvent categoryEvent;
  final String url;

  EventResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.organizer,
    required this.categoryEvent,
    required this.url,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      organizer: Organizer.fromJson(json['organizer']),
      categoryEvent: CategoryEvent.fromJson(json['categoryEvent']),
      url: json['url'],
    );
  }
}

class Organizer {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final TypeOfUser typeOfUser;
  final String url;

  Organizer({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.typeOfUser,
    required this.url,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      typeOfUser: TypeOfUser.fromJson(json['typeOfUser']),
      url: json['url'],
    );
  }
}

class TypeOfUser {
  final int typeId;
  final String description;

  TypeOfUser({
    required this.typeId,
    required this.description,
  });

  factory TypeOfUser.fromJson(Map<String, dynamic> json) {
    return TypeOfUser(
      typeId: json['typeId'],
      description: json['description'],
    );
  }
}

class CategoryEvent {
  final int id;
  final String name;

  CategoryEvent({
    required this.id,
    required this.name,
  });

  factory CategoryEvent.fromJson(Map<String, dynamic> json) {
    return CategoryEvent(
      id: json['id'],
      name: json['name'],
    );
  }
}