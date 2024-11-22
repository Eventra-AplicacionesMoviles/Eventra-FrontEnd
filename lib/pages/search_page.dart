import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'filter_page.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';
import '../models/event_response.dart';
import 'dart:async';
import 'event_detail_page.dart';

class SearchPage extends StatefulWidget {
  final bool isAdmin;
  final int userId;

  const SearchPage({super.key, required this.isAdmin, required this.userId});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 1;
  TextEditingController _searchController = TextEditingController();
  final StreamController<List<EventResponse>> _eventsStreamController = StreamController.broadcast();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _eventsStreamController.close();
    super.dispose();
  }

  void _onSearchChanged() {
    _fetchEvents(_searchController.text);
  }

  Future<void> _fetchEvents([String query = '']) async {
    try {
      String? token = await storage.read(key: 'jwt_token');
      if (token == null) {
        _eventsStreamController.addError('Error: No token found');
        return;
      }
      List<EventResponse> events = query.isEmpty
          ? await ApiService().fetchEvents(token)
          : await ApiService().searchEvents(query, token);
      _eventsStreamController.add(events);
    } catch (e) {
      _eventsStreamController.addError('Failed to load events');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Buscar',
        isAdmin: widget.isAdmin,
        userId: widget.userId,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FiltersPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFA726)),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  categoryButton(Icons.music_note, 'Música'),
                  const SizedBox(width: 10),
                  categoryButton(Icons.theater_comedy, 'Teatro'),
                  const SizedBox(width: 10),
                  categoryButton(Icons.sports_soccer, 'Deportes'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Eventos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFA726)),
            ),
            const SizedBox(height: 10),
            StreamBuilder<List<EventResponse>>(
              stream: _eventsStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((event) => eventCard(event)).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('No events found');
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        isAdmin: widget.isAdmin,
        userId: widget.userId,
      ),
    );
  }

  Widget categoryButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFA726),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget eventCard(EventResponse event) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(event.url, width: 80, fit: BoxFit.cover),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(event.startDate.toString(), style: const TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(event.endDate.toString(), style: const TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            String? token = await storage.read(key: 'jwt_token');
            if (token != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(
                    eventId: event.id,
                    imagePath: event.url,
                    title: event.title,
                    date: event.startDate.toString(),
                    time: event.endDate.toString(),
                    location: event.location,
                    organizer: '${event.organizer.firstName} ${event.organizer.lastName}',
                    description: event.description,
                    isAdmin: widget.isAdmin,
                    userId: widget.userId,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: No token found')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFA726),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Ver', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}