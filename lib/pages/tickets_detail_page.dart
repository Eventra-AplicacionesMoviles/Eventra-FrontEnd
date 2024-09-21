import 'package:flutter/material.dart';

class TicketDetailPage extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String image;
  final String description;

  TicketDetailPage({
    required this.title,
    required this.date,
    required this.time,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Mi Ticket',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.orange),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/user_profile.png'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del evento
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(image, fit: BoxFit.cover, width: double.infinity),
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18),
                          SizedBox(width: 8),
                          Text(date),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18),
                          SizedBox(width: 8),
                          Text(time),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18),
                          SizedBox(width: 8),
                          Text('Parque Central, Lima'),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Descripción:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(description),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.asset(
                    'assets/qr_code.png',
                    width: 80.0,
                    height: 80.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.download),
                label: Text('Descargar ticket'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: IconButton(
                icon: Icon(Icons.share, color: Colors.blue, size: 30),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}