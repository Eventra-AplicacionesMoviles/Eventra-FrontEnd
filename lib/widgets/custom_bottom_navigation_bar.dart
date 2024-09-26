import 'package:eventra_app/pages/add_event_page.dart';
import 'package:flutter/material.dart';
import '../pages/search_page.dart';
import '../pages/reservation_page.dart';
import '../pages/tickets_page.dart';
import '../pages/profile_page.dart';
import '../pages/home_page.dart';
import '../pages/login.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
      selectedItemColor: const Color(0xFFFFA726),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 5) {
          _showBottomSheet(context);
        } else {
          onTap(index);
          _navigateToPage(context, index);
        }
      },
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddEventPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TicketsPage()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }

  void _showBottomSheet(BuildContext context) {
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
                onTap: () {

                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.black87),
                title: const Text('Ayuda'),
                onTap: () {

                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.black87),
                title: const Text('Términos y condiciones'),
                onTap: () {

                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
