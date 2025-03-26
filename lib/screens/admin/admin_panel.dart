import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ayamgepuk/database/database.dart';
import 'package:ayamgepuk/screens/admin/admin_booking_summary.dart';
import 'admin_edit_booking_screen.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  late Future<List<Map<String, dynamic>>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  void _refreshBookings() {
    _bookingsFuture = _fetchBookings();
    setState(() {}); // Refresh the UI
  }

  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    final db = DatabaseService();
    return await db.getAllCustomerBookings();
  }

  Future<void> _deleteBooking(int bookingId) async {
    final db = DatabaseService();
    try {
      await db.deleteBooking(bookingId);
      _refreshBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting booking: $e')),
      );
    }
  }

  List<Map<String, dynamic>> _parseMenuPackage(String menuPackageJson) {
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(menuPackageJson));
    } catch (e) {
      print('Error parsing menu package: $e');
      return [];
    }
  }

  void _navigateToEditBooking(Map<String, dynamic> booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminEditBookingScreen(
          booking: booking,
          onBookingUpdated: (updatedBooking) => _refreshBookings(),
        ),
      ),
    );
  }

  void _navigateToBookingSummary(Map<String, dynamic> booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => adminBookingSummary(
          userId: booking['userid'] ?? 0,
          bookingDateTime: booking['bookdate'] != null
              ? DateTime.parse(booking['bookdate'])
              : DateTime.now(),
          eventDate: booking['eventdate'] ?? 'Unknown',
          eventTime: booking['eventtime'] ?? 'Unknown',
          selectedMenu: _parseMenuPackage(booking['menupackage'] ?? '[]'),
          totalPrice: booking['packageprice']?.toDouble() ?? 0.0,
          numGuest: booking['numguest'] ?? 0,
          bookId: booking['bookid'] ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bookings'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(booking['bookid'].toString()),
                  ),
                  title: Text('Event on ${booking['eventdate'] ?? 'Unknown'}'),
                  subtitle: Text(
                    'Time: ${booking['eventtime'] ?? 'Unknown'}\nGuests: ${booking['numguest'] ?? 0}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => _navigateToBookingSummary(booking),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToEditBooking(booking),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Booking'),
                              content: const Text(
                                  'Are you sure you want to delete this booking?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await _deleteBooking(booking['bookid']);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
