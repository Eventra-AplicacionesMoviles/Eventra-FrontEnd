import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/event_request.dart';
import '../models/category_event_response.dart';
import '../models/event_response.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8080/api';

  Future<List<CategoryEventResponse>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categoryevent'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => CategoryEventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories: ${response.reasonPhrase}');
    }
  }

  Future<void> createEvent(EventRequest eventRequest) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(eventRequest.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create event: ${response.reasonPhrase}');
    }
  }

  Future<List<EventResponse>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => EventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events: ${response.reasonPhrase}');
    }
  }

  Future<List<EventResponse>> fetchEventsByUserId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/events/user/$userId'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => EventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events for user: ${response.reasonPhrase}');
    }
  }

  Future<void> updateEvent(int eventId, EventRequest eventRequest) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(eventRequest.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update event: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    final response = await http.delete(Uri.parse('$baseUrl/events/$eventId'));
    if (response.statusCode != 204) { // 204 No Content is the expected response for a successful delete
      throw Exception('Failed to delete event: ${response.reasonPhrase}');
    }
  }

  Future<List<EventResponse>> searchEvents(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/events/title/$query'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => EventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search events: ${response.reasonPhrase}');
    }
  }
}