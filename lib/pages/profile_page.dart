import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'edit_profile_page.dart';
import 'my_events_page.dart';
import '../services/api_service.dart';
import '../models/user_response.dart';

class ProfilePage extends StatefulWidget {
  final bool isAdmin;
  final int userId;

  const ProfilePage({super.key, required this.isAdmin, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserResponse?> _userDetails;
  final storage = FlutterSecureStorage();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    String? token = await storage.read(key: 'jwt_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No token found')),
      );
      return;
    }
    setState(() {
      _userDetails = ApiService().fetchUserDetails(widget.userId, token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFFFFA726),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFA726)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<UserResponse?>(
            future: _userDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading user details'));
              } else if (snapshot.hasData && snapshot.data != null) {
                UserResponse user = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(user.url),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoTile(Icons.email, user.email, context),
                    _buildInfoTile(Icons.person, '${user.firstName} ${user.lastName}', context),
                    _buildPasswordTile(user.password),
                    _buildInfoTile(Icons.account_box, user.typeOfUser.description == 'admin' ? 'Organizador' : 'Cliente', context),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfilePage(isAdmin: widget.isAdmin, userId: widget.userId, password: user.password)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text(
                          'Editar Perfil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyEventsPage(isAdmin: widget.isAdmin, userId: widget.userId)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text(
                          'Mis Eventos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No user details found'));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFFFA726),
          size: 30,
        ),
        title: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildPasswordTile(String password) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(
          Icons.lock,
          color: Color(0xFFFFA726),
          size: 30,
        ),
        title: TextFormField(
          initialValue: password,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFFFFA726),
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          readOnly: true,
        ),
      ),
    );
  }
}