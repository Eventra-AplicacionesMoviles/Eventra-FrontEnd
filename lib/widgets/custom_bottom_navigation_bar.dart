import 'package:eventra_app/pages/add_event_page.dart';
import 'package:flutter/material.dart';
import '../pages/search_page.dart';
import '../pages/reservation_page.dart';
import '../pages/tickets_page.dart';
import '../pages/profile_page.dart';
import '../pages/home_page.dart';
import '../pages/login.dart';
import '../pages/my_events_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isAdmin;
  final int userId; // Add userId parameter

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.isAdmin,
    required this.userId, // Add this parameter to the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = isAdmin ? _adminItems() : _userItems();
    final validIndex = currentIndex >= 0 && currentIndex < items.length ? currentIndex : 0;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: items,
      selectedItemColor: const Color(0xFFFFA726),
      unselectedItemColor: Colors.grey,
      currentIndex: validIndex,
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

  List<BottomNavigationBarItem> _adminItems() {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
    ];
  }

  List<BottomNavigationBarItem> _userItems() {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.event), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
    ];
  }

  void _navigateToPage(BuildContext context, int index) {
    if (isAdmin) {
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(isAdmin: isAdmin, userId: userId)),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SearchPage(isAdmin: isAdmin, userId: userId)),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TicketsPage(isAdmin: isAdmin, userId: userId)),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ReservationPage(isAdmin: isAdmin, userId: userId)),
          );
          break;
        case 4:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(isAdmin: isAdmin, userId: userId)),
          );
          break;
        case 5:
          _showBottomSheet(context);
          break;
      }
    } else {
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyEventsPage(isAdmin: isAdmin, userId: userId)),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddEventPage(isAdmin: isAdmin, userId: userId)),
          );
          break;
        case 2:
          _showBottomSheet(context);
          break;
      }
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
                title: const Text('Change Account'),
                onTap: () {
                  // Implement account change logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.black87),
                title: const Text('Help'),
                onTap: () {
                  // Implement help logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.black87),
                title: const Text('Terms and Conditions'),
                onTap: () {
                  // Implement terms and conditions logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Logout'),
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