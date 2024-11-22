import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/event_request.dart';
import '../models/category_event_response.dart';
import '../models/event_response.dart';
import '../models/user_response.dart';
import '../models/user_request.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8080/api';

  Future<List<CategoryEventResponse>> fetchCategories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categoryevent'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => CategoryEventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories: ${response.reasonPhrase}');
    }
  }

  Future<void> createEvent(EventRequest eventRequest, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(eventRequest.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create event: ${response.reasonPhrase}');
    }
  }

  Future<List<EventResponse>> fetchEvents(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => EventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events: ${response.reasonPhrase}');
    }
  }

  Future<List<EventResponse>> fetchEventsByUserId(int userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/user/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => EventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events for user: ${response.reasonPhrase}');
    }
  }

  Future<void> updateEvent(int eventId, EventRequest eventRequest, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(eventRequest.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update event: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteEvent(int eventId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) { // 204 No Content is the expected response for a successful delete
      throw Exception('Failed to delete event: ${response.reasonPhrase}');
    }
  }

  Future<List<EventResponse>> searchEvents(String query, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/title/$query'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => EventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search events: ${response.reasonPhrase}');
    }
  }

  Future<List<EventResponse>> fetchUpcomingEvents(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<EventResponse> events = body.map((dynamic item) => EventResponse.fromJson(item)).toList();
      events.sort((a, b) => a.startDate.compareTo(b.startDate));
      return events.take(5).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<EventResponse>> fetchDistantEvents(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<EventResponse> events = body.map((dynamic item) => EventResponse.fromJson(item)).toList();
      events.sort((a, b) => b.startDate.compareTo(a.startDate));
      return events.take(5).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<UserResponse> fetchUserDetails(int userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return UserResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user details: ${response.reasonPhrase}');
    }
  }

  Future<void> updateUser(int userId, UserRequest userRequest, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the JWT token
      },
      body: json.encode(userRequest.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.reasonPhrase}');
    }
  }
}