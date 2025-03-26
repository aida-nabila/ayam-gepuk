import 'dart:convert';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../entry_point.dart';
import 'booking_summary_screen.dart';
import 'edit_booking_page.dart';

class CheckBookingScreen extends StatefulWidget {
  final int userId;

  const CheckBookingScreen({super.key, required this.userId});

  @override
  State<CheckBookingScreen> createState() => _CheckBookingScreenState();
}

class _CheckBookingScreenState extends State<CheckBookingScreen> {
  late Future<List<Map<String, dynamic>>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  void _refreshBookings() {
    _bookingsFuture = _fetchBookings(widget.userId);
    setState(() {}); // Refresh UI
  }

  Future<List<Map<String, dynamic>>> _fetchBookings(int userId) async {
    final db = DatabaseService();
    return await db.getBookingsByUserId(userId);
  }

  Future<void> _deleteBooking(int bookingId) async {
    final db = DatabaseService();
    await db.deleteBooking(bookingId);
    _refreshBookings();
  }

  List<Map<String, dynamic>> _parseMenuPackage(String menuPackageJson) {
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(menuPackageJson));
    } catch (e) {
      print('Error parsing menu package: $e');
      return [];
    }
  }

  void _navigateToBookingSummary(Map<String, dynamic> booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSummaryScreen(
          userId: booking['userid'] ?? 0,
          bookingDateTime: booking['bookdate'] != null
              ? DateTime.parse(booking['bookdate'])
              : DateTime.now(),
          eventDate: booking['eventdate'] ?? 'Unknown',
          eventTime: booking['eventtime'] ?? 'Unknown',
          selectedMenu: booking['menupackage'] != null
              ? _parseMenuPackage(booking['menupackage'])
              : [],
          totalPrice: booking['packageprice']?.toDouble() ?? 0.0,
          numGuest: booking['numguest'] ?? 0,
          bookId: booking['bookid'] ?? 0,
        ),
      ),
    );
  }

  void _navigateToEditPage(Map<String, dynamic> booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookingPage(
          booking: booking,
          onBookingUpdated: (updatedBooking) {
            _refreshBookings(); // Refresh bookings when an edit is saved
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const EntryPoint(selectedTabIndex: 3), // Set to Profile tab
              ),
              (route) => false,
            );
          },
        ),
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
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToEditPage(booking),
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
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
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
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => _navigateToBookingSummary(booking),
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
