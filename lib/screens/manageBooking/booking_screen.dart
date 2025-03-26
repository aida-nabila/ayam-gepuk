import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ayamgepuk/database/database.dart';

import 'booking_summary_screen.dart';

class BookingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedMenu;
  final double totalPrice;

  const BookingScreen({
    super.key,
    required this.selectedMenu,
    required this.totalPrice,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _eventDateController = TextEditingController();
  final _eventTimeController = TextEditingController();
  final _numGuestsController = TextEditingController();

  // Fetch logged-in user's information
  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Guest';
    String email = prefs.getString('email') ?? 'No Email Provided';
    String phone = prefs.getString('phone') ?? 'No Phone Provided';
    return {
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

  // Function to pick date
  Future<void> _pickEventDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _eventDateController.text = DateFormat('yyyy-MM-dd')
            .format(pickedDate); // Use consistent format
      });
    }
  }

  // Function to pick time
  Future<void> _pickEventTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _eventTimeController.text =
            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}'; // Format time as HH:mm
      });
    }
  }

  // Clear all fields
  void _clearFields() {
    _eventDateController.clear();
    _eventTimeController.clear();
    _numGuestsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Event'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info (Non-editable fields)
                    TextFormField(
                      controller: TextEditingController(
                          text: snapshot.data!['username']),
                      decoration: const InputDecoration(labelText: 'Name'),
                      enabled: false, // Disable editing
                      style: const TextStyle(
                          color: Colors.grey), // Grey out the text
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: snapshot.data!['phone']),
                      decoration: const InputDecoration(labelText: 'Phone'),
                      enabled: false,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: snapshot.data!['email']),
                      decoration: const InputDecoration(labelText: 'Email'),
                      enabled: false,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16.0),

                    // Event info (Editable fields)
                    GestureDetector(
                      onTap: _pickEventDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _eventDateController,
                          decoration: const InputDecoration(
                            labelText: 'Event Date',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an event date.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: _pickEventTime,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _eventTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Event Time',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an event time.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _numGuestsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Number of Guests',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of guests.';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Please enter a valid number of guests.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Clear Button
                    ElevatedButton(
                      onPressed: _clearFields,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey), // Grey color for clear button
                      child: const Text('Clear All Fields'),
                    ),
                    // Submit Button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final prefs = await SharedPreferences.getInstance();
                          int userId = prefs.getInt('userId') ?? 0;
                          int numGuests = int.parse(_numGuestsController.text);

                          // Serialize the selected menu
                          String serializedMenu =
                              json.encode(widget.selectedMenu);

                          // Prepare the booking data
                          Map<String, dynamic> menubook = {
                            'userid': userId,
                            'bookdate': DateFormat('yyyy-MM-dd')
                                .format(DateTime.now()), // Updated format
                            'booktime': DateFormat('HH:mm:ss')
                                .format(DateTime.now()), // Updated format
                            'eventdate': _eventDateController.text,
                            'eventtime': _eventTimeController.text,
                            'menupackage':
                                serializedMenu, // Store serialized menu
                            'numguest': numGuests,
                            'packageprice': widget.totalPrice,
                          };

                          // Save the booking in the database and get the generated book ID
                          int bookId =
                              await DatabaseService().insertMenuBook(menubook);

                          // Navigate to BookingSummaryScreen with the book ID
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingSummaryScreen(
                                userId: userId,
                                bookingDateTime: DateTime.now(),
                                eventDate: _eventDateController.text,
                                eventTime: _eventTimeController.text,
                                numGuest: numGuests,
                                selectedMenu: widget.selectedMenu,
                                totalPrice: widget.totalPrice,
                                bookId: bookId, // Pass the book ID here
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit Booking'),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
