import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ticket.dart';

class TicketService {
  final String baseUrl;

  TicketService(this.baseUrl);

  Future<List<Ticket>> fetchTickets() async {
    final response = await http.get(Uri.parse('$baseUrl/api/tickets'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  Future<Ticket> fetchTicketById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/tickets/$id'));
    if (response.statusCode == 200) {
      return Ticket.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load ticket');
    }
  }
}