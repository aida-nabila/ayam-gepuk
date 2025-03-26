import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_panel.dart';
import 'package:ayamgepuk/screens/auth/sign_in_screen.dart';

import '../manageUsers/manage_users.dart';

const primaryColor = Color(0xFFEF5350);

class AdminSelectionPage extends StatefulWidget {
  const AdminSelectionPage({super.key});

  @override
  State<AdminSelectionPage> createState() => _AdminSelectionPageState();
}

class _AdminSelectionPageState extends State<AdminSelectionPage> {
  String adminName = "Admin"; // Default name

  @override
  void initState() {
    super.initState();
    _loadAdminName();
  }

  Future<void> _loadAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('adminUsername') ?? "Admin";
    setState(() {
      adminName = name;
    });
  }

  Future<void> logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isAdminLoggedIn');
    prefs.remove('adminUsername');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back button
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logOut(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.3),
              primaryColor.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome, $adminName',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'What would you like to manage today?',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildSelectionButton(
                  context,
                  icon: Icons.event_note,
                  label: 'Manage Bookings',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPanelPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildSelectionButton(
                  context,
                  icon: Icons.people,
                  label: 'Manage Users',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageUsersPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
