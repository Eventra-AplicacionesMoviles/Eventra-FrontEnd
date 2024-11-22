import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'event_detail_page.dart'; // Ensure this import is present
import 'tickets_page.dart';
import 'search_page.dart';
import 'reservation_page.dart';
import 'add_event_page.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../services/api_service.dart';
import '../models/event_response.dart';
import '../models/user_response.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;
  final int userId;

  const HomePage({super.key, required this.isAdmin, required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Future<List<EventResponse>>? _upcomingEvents;
  Future<List<EventResponse>>? _distantEvents;
  Future<UserResponse?>? _userDetails; // Changed to nullable
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String? token = await storage.read(key: 'jwt_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No token found')),
      );
      return;
    }

    setState(() {
      _upcomingEvents = ApiService().fetchUpcomingEvents(token);
      _distantEvents = ApiService().fetchDistantEvents(token);
      _userDetails = ApiService().fetchUserDetails(widget.userId, token);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage(isAdmin: widget.isAdmin, userId: widget.userId)),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddEventPage(isAdmin: widget.isAdmin, userId: widget.userId)),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReservationPage(isAdmin: widget.isAdmin, userId: widget.userId)),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TicketsPage(isAdmin: widget.isAdmin, userId: widget.userId)),
      );
    } else if (index == 5) {
      _showBottomSheet();
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.black87),
                title: const Text('Cambiar cuenta'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.black87),
                title: const Text('Ayuda'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.black87),
                title: const Text('Términos y condiciones'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Cerrar sesión'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Eventra',
        isAdmin: widget.isAdmin,
        userId: widget.userId,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<UserResponse?>(
              future: _userDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading user details');
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Text(
                    'Hello, ${snapshot.data!.firstName}!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFA726)),
                  );
                } else {
                  return const Text('Hello, user!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFA726)));
                }
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Próximos eventos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFA726)),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<EventResponse>>(
              future: _upcomingEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!.map((event) => _buildUpcomingEventCard(context, event)).toList(),
                    ),
                  );
                } else {
                  return const Text('No upcoming events found');
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Eventos populares',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFFA726)),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<EventResponse>>(
              future: _distantEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: snapshot.data!.map((event) => _buildPopularEventTile(context, event)).toList(),
                  );
                } else {
                  return const Text('No popular events found');
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

  Widget _buildUpcomingEventCard(BuildContext context, EventResponse event) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: const Color(0xFFFFA726).withOpacity(0.2),
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(event.url, fit: BoxFit.cover, height: 100, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFFA726)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        String? token = await storage.read(key: 'jwt_token');
                        if (token != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EventDetailPage(
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
                            )),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error: No token found')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Inscríbete', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularEventTile(BuildContext context, EventResponse event) {
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