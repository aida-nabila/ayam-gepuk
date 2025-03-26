import 'package:ayamgepuk/screens/admin/admin_panel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class adminBookingSummary extends StatelessWidget {
  final int userId;
  final DateTime bookingDateTime;
  final String eventDate;
  final String eventTime;
  final List<Map<String, dynamic>> selectedMenu;
  final double totalPrice;
  final int numGuest;
  final int bookId;

  const adminBookingSummary({
    super.key,
    required this.userId,
    required this.bookingDateTime,
    required this.eventDate,
    required this.eventTime,
    required this.selectedMenu,
    required this.totalPrice,
    required this.numGuest,
    required this.bookId,
  });

  String _formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    print("Booking ID: $bookId");
    print("User ID: $userId");
    print("Menu Package: $selectedMenu");
    print("Total Price: $totalPrice");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Booking Receipt',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            _buildDetailRow('Booking ID:', bookId.toString()),
            _buildDetailRow('User ID:', userId.toString()),
            _buildDetailRow('Booking Date:',
                bookingDateTime.toLocal().toString().split(' ')[0]),
            _buildDetailRow(
                'Booking Time:', _formatTime(bookingDateTime.toLocal())),
            _buildDetailRow(
                'Event Date:', eventDate.isEmpty ? 'Unknown' : eventDate),
            _buildDetailRow(
                'Event Time:', eventTime.isEmpty ? 'Unknown' : eventTime),
            _buildDetailRow('Number of Guests:', numGuest.toString()),
            const Divider(),
            const SizedBox(height: 16.0),
            const Text(
              'Selected Menu:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ...selectedMenu.map(
              (item) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item['quantity']} x ${item['title']}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'RM ${(item['quantity'] * item['price']).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            _buildDetailRow(
              'Total Price:',
              'RM ${totalPrice.toStringAsFixed(2)}',
              isBold: true,
            ),
            const Divider(),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPanelPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
