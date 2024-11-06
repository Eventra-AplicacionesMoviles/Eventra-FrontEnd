import 'category_event_response.dart';
import 'organizer.dart';
class Event {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final Organizer organizer;
  final CategoryEventResponse categoryEvent;
  final String url;

  Event({
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

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      organizer: Organizer.fromJson(json['organizer']),
      categoryEvent: CategoryEventResponse.fromJson(json['categoryEvent']),
      url: json['url'],
    );
  }
}