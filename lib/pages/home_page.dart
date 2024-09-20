import 'package:flutter/material.dart';
import 'event_detail_page.dart';
import 'tickets_page.dart'; // Importa la página de Tickets

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice inicial del BottomNavigationBar

  // Método para cambiar de página
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) { // Índice del botón de Tickets
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TicketsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            SizedBox(width: 10),
            Text(
              'Eventra',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.orange),
              onPressed: () {},
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/user_profile.png'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo y Sección de Próximos Eventos
            Text(
              'Hello, user!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Próximos eventos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildUpcomingEventCard(context, 'assets/concert.png', 'Concierto'),
                  SizedBox(width: 10),
                  _buildUpcomingEventCard(context, 'assets/theater.png', 'Obra de teatro'),
                ],
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Eventos populares',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildPopularEventTile(context, 'Music Festival', '10 Noviembre', '6:00 pm', 'assets/music_festival.png'),
            _buildPopularEventTile(context, 'Exposición', '15 Octubre', '4:00 pm', 'assets/exhibition.png'),
            _buildPopularEventTile(context, 'Taller', '25 Setiembre', '3:00 pm', 'assets/workshop.png'),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  minimumSize: Size(150, 50),
                ),
                child: Text('Ver más'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex, // Muestra el índice seleccionado
        onTap: _onItemTapped, // Llama al método cuando se hace clic
      ),
    );
  }

  Widget _buildUpcomingEventCard(BuildContext context, String imagePath, String title) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 200,
        child: Column(
          children: [
            Image.asset(imagePath, fit: BoxFit.cover, height: 100, width: double.infinity),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(imagePath: imagePath, title: title),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: Text('Inscríbete'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para Eventos Populares
  Widget _buildPopularEventTile(BuildContext context, String title, String date, String time, String imagePath) {
    return Card(
      color: Color(0xFFFFA726),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(imagePath, width: 80, fit: BoxFit.cover),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                SizedBox(width: 5),
                Text(date),
              ],
            ),
            Row(
              children: [
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 5),
                Text(time),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailPage(imagePath: imagePath, title: title),
              ),
            );
          },
        ),
      ),
    );
  }
}
