import 'package:flutter/material.dart';
import 'package:ayamgepuk/database/database.dart';

class PasswordChangeScreen extends StatefulWidget {
  final int userId; // User ID to identify which user's password to change

  const PasswordChangeScreen({super.key, required this.userId});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Variables to toggle password visibility
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final db = DatabaseService();
      final user = await db.getUserById(widget.userId);

      if (user != null && user['password'] == _currentPasswordController.text.trim()) {
        if (_newPasswordController.text.trim() == _confirmPasswordController.text.trim()) {
          // Update password
          final updatedUser = {
            'userid': widget.userId,
            'name': user['name'],
            'email': user['email'],
            'phone': user['phone'],
            'username': user['username'],
            'password': _newPasswordController.text.trim(),
          };

          await db.updateUser(updatedUser);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully!')),
          );
          Navigator.pop(context); // Navigate back after password change
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New passwords do not match!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Current password is incorrect!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                _currentPasswordController,
                'Enter Current Password',
                obscureText: !_isCurrentPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                  });
                },
                isPasswordVisible: _isCurrentPasswordVisible,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                _newPasswordController,
                'Enter New Password',
                obscureText: !_isNewPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                },
                isPasswordVisible: _isNewPasswordVisible,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                _confirmPasswordController,
                'Confirm New Password',
                obscureText: !_isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                isPasswordVisible: _isConfirmPasswordVisible,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildPasswordField(
    TextEditingController controller,
    String label, {
    required bool obscureText,
    required VoidCallback toggleVisibility,
    required bool isPasswordVisible,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
