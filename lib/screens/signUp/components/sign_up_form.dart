import 'package:ayamgepuk/screens/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:ayamgepuk/database/database.dart';
import '../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Insert new user into the database
        await _databaseService.insertUser({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'username': usernameController.text,
          'password': passwordController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful!')),
        );

        // Navigate to the SignInScreen after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SignInScreen(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name input
          TextFormField(
            controller: nameController,
            validator: requiredValidator.call,
            decoration: const InputDecoration(hintText: "Full Name"),
          ),
          const SizedBox(height: 16.0),

          // Username input
          TextFormField(
            controller: usernameController,
            validator: requiredValidator.call,
            decoration: const InputDecoration(hintText: "Username"),
          ),
          const SizedBox(height: 16.0),

          // Email Address input
          TextFormField(
            controller: emailController,
            validator: emailValidator.call,
            decoration: const InputDecoration(hintText: "Email Address"),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),

          // Phone Number input
          TextFormField(
            controller: phoneController,
            validator: phoneNumberValidator.call,
            decoration: const InputDecoration(hintText: "Phone Number"),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16.0),

          // Password input
          TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            validator: passwordValidator.call,
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
          const SizedBox(height: 16.0),

          // Confirm Password input
          TextFormField(
            controller: confirmPasswordController,
            obscureText: _obscureText,
            validator: (value) =>
                matchValidator.validateMatch(passwordController.text, value!),
            decoration: InputDecoration(
              hintText: "Confirm Password",
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
          const SizedBox(height: 16.0),

          // Sign Up button
          ElevatedButton(
            onPressed: _signUp,
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}
