import 'package:flutter/material.dart';
import 'package:ayamgepuk/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../entry_point.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final dbService = DatabaseService();
        final emailInput = emailController.text.trim();
        final passwordInput = passwordController.text.trim();

        // Fetch the complete user data from the database
        final user = await dbService.login(emailInput, passwordInput);

        if (user != null && user['userid'] != null) {
          // Store all user session data
          await _storeUserSession(user);

          // Show success SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign in successful!')),
          );

          // Navigate to EntryPoint
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const EntryPoint()),
            (_) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      } catch (e) {
        debugPrint('Error during sign-in: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _storeUserSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('userId', user['userid']);
    prefs.setString('username', user['username']);
    prefs.setString('email', user['email']);
    prefs.setString('phone', user['phone']);
    prefs.setString('name', user['name']);
    prefs.setBool('isLoggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text("Sign in"),
          ),
        ],
      ),
    );
  }
}
