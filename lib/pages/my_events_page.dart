import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/api_service.dart';
import '../models/event_response.dart';
import '../models/event_request.dart';

class MyEventsPage extends StatefulWidget {
  final bool isAdmin;
  final int userId;

  const MyEventsPage({super.key, required this.isAdmin, required this.userId});

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  List<EventResponse> _events = [];
  int _selectedIndex = 0;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      String? token = await storage.read(key: 'jwt_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No token found')),
        );
        return;
      }
      List<EventResponse> events = await ApiService().fetchEventsByUserId(widget.userId, token);
      setState(() {
        _events = events;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index
    // Add your navigation logic here
  }

  Future<void> _deleteEvent(int eventId) async {
    bool confirm = await _showDeleteConfirmationDialog();
    if (confirm) {
      try {
        String? token = await storage.read(key: 'jwt_token');
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: No token found')),
          );
          return;
        }
        await ApiService().deleteEvent(eventId, token);
        setState(() {
          _events.removeWhere((event) => event.id == eventId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete event')),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _editEvent(EventResponse event) async {
    EventRequest? updatedEvent = await _showEditEventDialog(event);
    if (updatedEvent != null) {
      try {
        String? token = await storage.read(key: 'jwt_token');
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: No token found')),
          );
          return;
        }
        await ApiService().updateEvent(event.id, updatedEvent, token);
        setState(() {
          int index = _events.indexWhere((e) => e.id == event.id);
          _events[index] = EventResponse.fromRequest(updatedEvent, event.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update event')),
        );
      }
    }
  }

  Future<EventRequest?> _showEditEventDialog(EventResponse event) async {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: event.title);
    final _descriptionController = TextEditingController(text: event.description);
    final _locationController = TextEditingController(text: event.location);
    final _urlController = TextEditingController(text: event.url);
    DateTime? _startDate = event.startDate;
    DateTime? _endDate = event.endDate;

    return await showDialog<EventRequest>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                ),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(labelText: 'URL'),
                  validator: (value) => value!.isEmpty ? 'Please enter a URL' : null,
                ),
                // Add date and time pickers for start and end dates
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop(EventRequest(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  startDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_startDate!),
                  endDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(_endDate!),
                  location: _locationController.text,
                  organizerId: event.organizer.id,
                  categoryId: event.categoryEvent.id,
                  url: _urlController.text,
                ));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Eventos'),
        backgroundColor: const Color(0xFFFFA726),
        elevation: 4,
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        event.url,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: Colors.black54,
                          child: Text(
                            'Categoría: ${event.categoryEvent.name}',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA726),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Descripción: ${event.description}',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ubicación: ${event.location}',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Inicio: ${DateFormat('yyyy-MM-dd – kk:mm').format(event.startDate)}',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                            Text(
                              'Fin: ${DateFormat('yyyy-MM-dd – kk:mm').format(event.endDate)}',
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Organizador: ${event.organizer.firstName} ${event.organizer.lastName}',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editEvent(event),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEvent(event.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        isAdmin: widget.isAdmin,
        userId: widget.userId,
      ),
    );
  }
}