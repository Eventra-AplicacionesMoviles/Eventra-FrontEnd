import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_request.dart';
import '../models/category_event_response.dart';
import '../models/event_response.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<void> createEvent(EventRequest eventRequest) async {
    final url = Uri.parse('$baseUrl/events');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(eventRequest.toJson()),
    );

    if (response.statusCode == 201) {
      print('Event created successfully');
    } else {
      print('Error creating event: ${response.body}');
    }
  }

  Future<List<CategoryEventResponse>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categoryevent'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => CategoryEventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // New method to fetch events created by the user
  Future<List<EventResponse>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => EventResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}