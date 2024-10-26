import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  // Lista estática de eventos con imágenes
  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Marron 5',
      'description': 'Concierto imperdible a todo dar',
      'location': 'Miraflores, Peru',
      'startDate': DateTime.now().add(Duration(days: 1)),
      'endDate': DateTime.now().add(Duration(days: 1, hours: 2)),
      'organizer': {'firstName': 'John', 'lastName': 'Doe'},
      'categoryEvent': {'name': 'Música'},
      'imageUrl': 'assets/jazz_festival.png', // Ruta de la imagen en assets
    },
    {
      'title': 'Halloween Party',
      'description': 'La mejor fiesta de halloween, no te la puedes perder',
      'location': 'La Molina, Peru',
      'startDate': DateTime.now().add(Duration(days: 2)),
      'endDate': DateTime.now().add(Duration(days: 2, hours: 3)),
      'organizer': {'firstName': 'Jane', 'lastName': 'Doe'},
      'categoryEvent': {'name': 'Fiesta'},
      'imageUrl': 'assets/party.png', // Ruta de la imagen en assets
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Eventos'),
        backgroundColor: const Color(0xFFFFA726),
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index]; // Usar la lista estática
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
                  // Mostrar imagen del evento desde assets
                  Image.asset(
                    event['imageUrl'], // Cargar la imagen desde assets
                    height: 200, // Ajusta la altura según sea necesario
                    width: double.infinity,
                    fit: BoxFit.cover, // Ajusta la imagen al espacio disponible
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA726),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Descripción: ${event['description']}',
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ubicación: ${event['location']}',
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Inicio: ${DateFormat('yyyy-MM-dd – kk:mm').format(event['startDate'])}',
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            Text(
                              'Fin: ${DateFormat('yyyy-MM-dd – kk:mm').format(event['endDate'])}',
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Organizador: ${event['organizer']['firstName']} ${event['organizer']['lastName']}',
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Categoría: ${event['categoryEvent']['name']}',
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
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
    );
  }
}
