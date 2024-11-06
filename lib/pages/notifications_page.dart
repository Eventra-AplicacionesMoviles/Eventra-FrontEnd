import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final bool isAdmin;
  final int userId; // Add userId parameter

  const NotificationsPage({super.key, required this.isAdmin, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: const Color(0xFFFFA726),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationTile('Nueva actualización disponible', 'Hace 1 hora'),
          _buildNotificationTile('Evento próximo: Concierto', 'Hace 3 horas'),
          _buildNotificationTile('Tu reserva ha sido confirmada', 'Ayer'),
        ],
      ),
    );
  }

  // Método para construir cada notificación con diseño moderno
  Widget _buildNotificationTile(String title, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Color(0xFFFFA726)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
        onTap: () {
          // Add navigation logic here if needed
        },
      ),
    );
  }
}