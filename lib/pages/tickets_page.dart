import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_app_bar.dart';
import 'tickets_detail_page.dart';

class TicketsPage extends StatefulWidget {
  final bool isAdmin;
  final int userId;

  const TicketsPage({super.key, required this.isAdmin, required this.userId});

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  int _selectedIndex = 3;
  List<dynamic> upcomingTickets = [];
  List<dynamic> pastTickets = [];

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final response = await http.get(Uri.parse('http://your-backend-url/api/tickets'));

    if (response.statusCode == 200) {
      final List<dynamic> tickets = json.decode(response.body);
      setState(() {
        upcomingTickets = tickets.where((ticket) => DateTime.parse(ticket['date']).isAfter(DateTime.now())).toList();
        pastTickets = tickets.where((ticket) => DateTime.parse(ticket['date']).isBefore(DateTime.now())).toList();
      });
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Eventra',
          isAdmin: widget.isAdmin,
          userId: widget.userId,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Próximo'),
              Tab(text: 'Pasado'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: upcomingTickets.map((ticket) => _buildTicketCard(
                context,
                image: ticket['image'],
                title: ticket['title'],
                date: ticket['date'],
                time: ticket['time'],
                description: ticket['description'],
              )).toList(),
            ),
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: pastTickets.map((ticket) => _buildTicketCard(
                context,
                image: ticket['image'],
                title: ticket['title'],
                date: ticket['date'],
                time: ticket['time'],
                description: ticket['description'],
              )).toList(),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          isAdmin: widget.isAdmin,
          userId: widget.userId,
        ),
      ),
    );
  }

  Widget _buildTicketCard(
      BuildContext context, {
        required String image,
        required String title,
        required String date,
        required String time,
        required String description,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: Colors.white,
      shadowColor: Colors.grey.shade200,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Color(0xFFFFA726)),
                const SizedBox(width: 5),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Color(0xFFFFA726)),
                const SizedBox(width: 5),
                Text(time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ],
        ),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketDetailPage(
                  title: title,
                  date: date,
                  time: time,
                  image: image,
                  description: description,
                ),
              ),
            );
          },
          child: const Text('Ver Detalles', style: TextStyle(color: Color(0xFFFFA726))),
        ),
      ),
    );
  }
}