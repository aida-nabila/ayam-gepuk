import 'package:ayamgepuk/database/database.dart';
import 'package:flutter/material.dart';

class AdminSetupScreen extends StatefulWidget {
  @override
  _AdminSetupScreenState createState() => _AdminSetupScreenState();
}

class _AdminSetupScreenState extends State<AdminSetupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  Future<void> _submit() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Please enter both username and password.';
      });
      return;
    }

    final dbService = DatabaseService();
    await dbService.addAdmin(username, password);
    setState(() {
      _message = 'Admin user added successfully!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Add Admin'),
            ),
            if (_message.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(_message, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
