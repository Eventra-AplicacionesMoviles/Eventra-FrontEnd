import 'package:flutter/material.dart';
import 'tickets_detail_page.dart';

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              Image.asset('assets/logo.png', height: 40), // Ruta del logo
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
                backgroundImage: AssetImage('assets/user_profile.png'), // Imagen de perfil
              ),
            ],
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Próximo'),
              Tab(text: 'Pasado'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildTicketCard(
                  context,
                  image: 'assets/jazz_festival.png',
                  title: 'Jazz Festival',
                  date: '25 Noviembre',
                  time: '7:00 pm',
                  description: 'Un festival de jazz con artistas internacionales.',
                ),
                _buildTicketCard(
                  context,
                  image: 'assets/music_festival.png',
                  title: 'Music Festival',
                  date: '10 Noviembre',
                  time: '6:00 pm',
                  description: 'Un festival de música y arte vibrante que celebra la cultura.',
                ),
                _buildTicketCard(
                  context,
                  image: 'assets/food_festival.png',
                  title: 'Festival de comida',
                  date: '5 Octubre',
                  time: '12:00 pm',
                  description: 'Un festival para degustar comidas de diferentes culturas.',
                ),
                _buildTicketCard(
                  context,
                  image: 'assets/ceramics_workshop.png',
                  title: 'Taller de cerámica',
                  date: '10 Octubre',
                  time: '6:00 pm',
                  description: 'Un taller donde puedes aprender a hacer piezas de cerámica.',
                ),
              ],
            ),
            // Tab de Pasado (por ahora vacío)
            Center(
              child: Text('No hay eventos pasados.'),
            ),
          ],
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
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, {required String image, required String title, required String date, required String time, required String description}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.orange.shade200,
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.black),
                SizedBox(width: 5),
                Text(date, style: TextStyle(fontSize: 12)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.black),
                SizedBox(width: 5),
                Text(time, style: TextStyle(fontSize: 12)),
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
          child: Text('Ver Detalles', style: TextStyle(color: Colors.orange)),
        ),
      ),
    );
  }
}