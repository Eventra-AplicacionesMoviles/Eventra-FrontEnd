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
      id: json['id'] ?? 0, // Provide a default value of 0 if null
      title: json['title'] ?? '', // Provide a default value of empty string if null
      description: json['description'] ?? '', // Provide a default value of empty string if null
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()), // Provide current date if null
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()), // Provide current date if null
      location: json['location'] ?? '', // Provide a default value of empty string if null
      organizer: Organizer.fromJson(json['organizer'] ?? {}), // Provide an empty map if null
      categoryEvent: CategoryEventResponse.fromJson(json['categoryEvent'] ?? {}), // Provide an empty map if null
      url: json['url'] ?? '', // Provide a default value of empty string if null
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