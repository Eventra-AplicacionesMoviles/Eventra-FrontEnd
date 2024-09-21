import 'package:flutter/material.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_app_bar.dart';
import 'tickets_detail_page.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  int _selectedIndex = 3;

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
            const Center(
              child: Text(
                'No hay eventos pasados.',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
          child: Image.asset(
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