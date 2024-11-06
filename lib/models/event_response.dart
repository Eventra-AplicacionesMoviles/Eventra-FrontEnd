import 'category_event_response.dart';
import 'organizer.dart';
import 'event_request.dart';

class EventResponse {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final Organizer organizer;
  final CategoryEventResponse categoryEvent;
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
      categoryEvent: CategoryEventResponse.fromJson(json['categoryEvent']),
      url: json['url'],
    );
  }

  factory EventResponse.fromRequest(EventRequest request, int id) {
    return EventResponse(
      id: id,
      title: request.title,
      description: request.description,
      startDate: DateTime.parse(request.startDate),
      endDate: DateTime.parse(request.endDate),
      location: request.location,
      organizer: Organizer(id: request.organizerId, firstName: '', lastName: ''), // Placeholder values
      categoryEvent: CategoryEventResponse(id: request.categoryId, name: ''), // Placeholder values
      url: request.url,
    );
  }
}