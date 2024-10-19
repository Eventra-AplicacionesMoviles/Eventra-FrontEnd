import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/event_response.dart';
import 'package:intl/intl.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  List<EventResponse> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() async {
    try {
      List<EventResponse> events = await ApiService().fetchEvents();
      if (mounted) {
        setState(() {
          _events = events;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return ListTile(
            title: Text(event.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${event.description}'),
                Text('Location: ${event.location}'),
                Text('Start: ${DateFormat('yyyy-MM-dd – kk:mm').format(event.startDate)}'),
                Text('End: ${DateFormat('yyyy-MM-dd – kk:mm').format(event.endDate)}'),
                Text('Organizer: ${event.organizer.firstName} ${event.organizer.lastName}'),
                Text('Category: ${event.categoryEvent.name}'),
              ],
            ),
          );
        },
      ),
    );
  }
}