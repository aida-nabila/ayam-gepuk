import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../entry_point.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  // Log out method that clears user session data
  Future<void> _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('username');
    prefs.setBool('isLoggedIn', false); // Set isLoggedIn flag to false

    // After logging out, navigate to the EntryPoint or SignIn screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      ),
      (Route<dynamic> route) =>
          false, // Removes all previous routes from the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _logOut(context); // Call the log-out function
          },
          child: const Text("Log Out"),
        ),
      ),
    );
  }
}
