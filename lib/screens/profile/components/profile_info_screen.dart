import 'package:flutter/material.dart';
import 'package:ayamgepuk/database/database.dart';

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key, required this.title, required this.userId});

  final String title;
  final int userId;

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _username = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late Future<Map<String, dynamic>?> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _loadUserData(widget.userId);
  }

  Future<Map<String, dynamic>?> _loadUserData(int userId) async {
    final db = DatabaseService();
    return await db.getUserById(userId);
  }

  Future<void> _showConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Update'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_name.text}'),
            Text('Email: ${_email.text}'),
            Text('Phone: ${_phone.text}'),
            Text('Username: ${_username.text}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _updateUser();
    }
  }

  Future<void> _updateUser() async {
    final db = DatabaseService();
    final updatedUser = {
      'userid': widget.userId,
      'name': _name.text,
      'email': _email.text,
      'phone': _phone.text,
      'username': _username.text,
    };
    await db.updateUser(updatedUser); // Use updateUser instead of insertUser
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
    Navigator.pop(context);
  }

  Widget _buildUserInfoSection(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            _buildInfoRow('Name', user['name']),
            _buildInfoRow('Email', user['email']),
            _buildInfoRow('Phone', user['phone']),
            _buildInfoRow('Username', user['username']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found'));
          } else {
            final user = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildUserInfoSection(user),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_name, "Enter your Name"),
                        _buildTextField(_email, "Enter your Email",
                            inputType: TextInputType.emailAddress),
                        _buildTextField(_phone, "Enter your Phone Number",
                            inputType: TextInputType.phone),
                        _buildTextField(_username, "Enter your Username"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _showConfirmationDialog();
                            }
                          },
                          child: const Text("Update Profile"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
