import 'package:flutter/material.dart';
import 'filter_page.dart';

class SearchPage extends StatelessWidget {
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
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
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
            // Filtro añadido arriba de los eventos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categorías',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.black),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FiltersPage()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                categoryButton(Icons.music_note, 'Música'),
                categoryButton(Icons.book, 'Educación'),
                categoryButton(Icons.brush, 'Arte'),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Para ti',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: [
                  eventCard('Exposición', '15 Octubre', '4:00 pm', 'assets/music_festival.png'),
                  eventCard('Taller', '25 Setiembre', '3:00 pm', 'assets/workshop.png'),
                  eventCard('Obra', '28 Setiembre', '3:00 pm', 'assets/theater.png'),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Ver más'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueAccent,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget eventCard(String title, String date, String time, String imagePath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Icon(Icons.calendar_today, size: 14),
            SizedBox(width: 5),
            Text(date),
            SizedBox(width: 20),
            Icon(Icons.access_time, size: 14),
            SizedBox(width: 5),
            Text(time),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ),
    );
  }
}
