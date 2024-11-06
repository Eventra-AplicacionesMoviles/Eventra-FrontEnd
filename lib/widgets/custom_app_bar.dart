import 'package:flutter/material.dart';
import '../pages/notifications_page.dart';
import '../pages/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final bool isAdmin;
  final int userId; // Add userId parameter

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions = const [],
    this.bottom,
    required this.isAdmin,
    required this.userId, // Add this parameter to the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFFA726),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset('assets/logo.png', height: 40),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage(isAdmin: isAdmin, userId: userId)),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(isAdmin: isAdmin, userId: userId)),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/user_profile.png'),
            ),
          ),
          ...actions,
        ],
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}