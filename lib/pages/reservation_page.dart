import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class ReservationPage extends StatefulWidget {
  final bool isAdmin;
  final int userId; // Add userId parameter

  const ReservationPage({super.key, required this.isAdmin, required this.userId});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int _selectedIndex = 4; // Ensure the index corresponds to the current tab

  // List of reservations
  List<Map<String, String>> reservations = [
    {
      'title': 'Concierto',
      'date': '10 Noviembre',
      'time': '6:00 pm',
      'imagePath': 'assets/concert.png',
    },
    {
      'title': 'Obra de teatro',
      'date': '15 Octubre',
      'time': '4:00 pm',
      'imagePath': 'assets/theater.png',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to delete a reservation
  void _deleteReservation(int index) {
    setState(() {
      reservations.removeAt(index);
    });
  }

  // Method to show confirmation dialog
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas cancelar esta reservación?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                _deleteReservation(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Mis Reservaciones', isAdmin: widget.isAdmin, userId: widget.userId), // Pass the userId parameter here
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return _buildReservationTile(
            context,
            reservations[index]['title']!,
            reservations[index]['date']!,
            reservations[index]['time']!,
            reservations[index]['imagePath']!,
            index,
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        isAdmin: widget.isAdmin, // Pass the isAdmin parameter here
        userId: widget.userId, // Pass the userId parameter here
      ),
    );
  }

  Widget _buildReservationTile(
      BuildContext context, String title, String date, String time, String imagePath, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        date,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Cancelar') {
                  _showDeleteConfirmationDialog(index); // Show confirmation dialog
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Cancelar'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}