import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ayamgepuk/database/database.dart';
import 'package:intl/intl.dart';
import 'menu/menu_screen.dart';

class EditBookingPage extends StatefulWidget {
  final Map<String, dynamic> booking;
  final Function(Map<String, dynamic>) onBookingUpdated;

  const EditBookingPage({
    Key? key,
    required this.booking,
    required this.onBookingUpdated,
  }) : super(key: key);

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController _bookIdController;
  late TextEditingController _userIdController;
  late TextEditingController _bookDateController;
  late TextEditingController _bookTimeController;
  late TextEditingController _numGuestController;
  late double packagePrice;
  late List<Map<String, dynamic>> menuItems;
  DateTime? eventDate;
  TimeOfDay? eventTime;

  String? eventDateError;
  String? eventTimeError;
  String? numGuestError;
  String? menuPackageError;

  @override
  void initState() {
    super.initState();

    _bookIdController =
        TextEditingController(text: widget.booking['bookid'].toString());
    _userIdController =
        TextEditingController(text: widget.booking['userid'].toString());
    _bookDateController =
        TextEditingController(text: widget.booking['bookdate'].toString());
    _bookTimeController =
        TextEditingController(text: widget.booking['booktime'].toString());
    _numGuestController =
        TextEditingController(text: widget.booking['numguest'].toString());

    menuItems = _parseMenuPackage(widget.booking['menupackage'] ?? '[]');
    packagePrice = _calculatePackagePrice();

    eventDate = DateTime.tryParse(widget.booking['eventdate'] ?? '');
    final time = widget.booking['eventtime']?.split(':');
    if (time != null && time.length == 2) {
      eventTime = TimeOfDay(
        hour: int.tryParse(time[0]) ?? 0,
        minute: int.tryParse(time[1]) ?? 0,
      );
    }
  }

  List<Map<String, dynamic>> _parseMenuPackage(String menuPackageJson) {
    try {
      final List<dynamic> decoded = jsonDecode(menuPackageJson);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error parsing menu package: $e');
      return [];
    }
  }

  double _calculatePackagePrice() {
    double total = 0.0;
    for (var item in menuItems) {
      total += (item['price'] ?? 0.0) * (item['quantity'] ?? 0);
    }
    return total;
  }

  Future<void> _updateBooking() async {
    if (!_validateInputs()) return;

    final now = DateTime.now();
    final updatedBooking = {
      'bookid': int.parse(_bookIdController.text),
      'userid': int.parse(_userIdController.text),
      'bookdate': DateFormat('yyyy-MM-dd').format(now),
      'booktime': DateFormat('HH:mm:ss').format(now),
      'eventdate': DateFormat('yyyy-MM-dd').format(eventDate!),
      'eventtime':
          '${eventTime!.hour.toString().padLeft(2, '0')}:${eventTime!.minute.toString().padLeft(2, '0')}',
      'menupackage': jsonEncode(menuItems),
      'numguest': int.parse(_numGuestController.text),
      'packageprice': packagePrice,
    };

    final db = DatabaseService();
    await db.updateBookingFull(updatedBooking);

    widget.onBookingUpdated(updatedBooking);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking updated successfully!')),
    );

    Navigator.pop(context);
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      eventDateError = eventDate == null ? "Please select a valid date." : null;
      eventTimeError = eventTime == null ? "Please select a valid time." : null;
      numGuestError = _numGuestController.text.isEmpty ||
              int.tryParse(_numGuestController.text) == null
          ? "Please enter a valid number of guests."
          : null;
      menuPackageError = menuItems.isEmpty
          ? "You must select at least one menu package."
          : null;

      isValid = eventDateError == null &&
          eventTimeError == null &&
          numGuestError == null &&
          menuPackageError == null;
    });
    return isValid;
  }

  void _navigateToMenuScreen() async {
    Map<String, dynamic> selectedItems = {
      for (var item in menuItems)
        item['id'] ?? item['title']: {
          'title': item['title'] ?? 'Unnamed Item',
          'price': item['price'] ?? 0.0,
          'quantity': item['quantity'] ?? 0,
          'description': item['description'] ?? '',
        }
    };

    final updatedItems = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(
          selectedItems: selectedItems,
          onOrderView: (updatedItems) {},
          onRemove: (id, price) {},
          isForEditBooking: true, // Explicitly pass true here
        ),
      ),
    );

    if (updatedItems != null) {
      setState(() {
        menuItems = updatedItems.entries.map((entry) {
          return {
            'id': entry.key,
            'title': entry.value['title'],
            'price': entry.value['price'],
            'quantity': entry.value['quantity'],
            'description': entry.value['description'],
          };
        }).toList();
        packagePrice = _calculatePackagePrice();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _bookIdController,
              decoration: const InputDecoration(labelText: 'Booking ID'),
              enabled: false,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
              enabled: false,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _bookDateController,
              decoration: const InputDecoration(labelText: 'Booking Date'),
              enabled: false,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _bookTimeController,
              decoration: const InputDecoration(labelText: 'Booking Time'),
              enabled: false,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () async {
                DateTime now = DateTime.now();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: eventDate != null && eventDate!.isAfter(now)
                      ? eventDate!
                      : now,
                  firstDate: now,
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    eventDate = pickedDate;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                    errorText: eventDateError,
                  ),
                  controller: TextEditingController(
                    text: eventDate != null
                        ? DateFormat('yyyy-MM-dd').format(eventDate!)
                        : '',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: eventTime ?? TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    eventTime = pickedTime;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Event Time',
                    errorText: eventTimeError,
                  ),
                  controller: TextEditingController(
                    text: eventTime != null ? eventTime!.format(context) : '',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _numGuestController,
              decoration: InputDecoration(
                labelText: 'Number of Guests',
                errorText: numGuestError,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menu Package:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: _navigateToMenuScreen,
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            menuItems.isEmpty
                ? Text(
                    menuPackageError ?? 'No menu package selected.',
                    style: TextStyle(
                      color:
                          menuPackageError != null ? Colors.red : Colors.black,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final menuItem = menuItems[index];
                      return ListTile(
                        title: Text(menuItem['title'] ?? 'Unnamed Item'),
                        subtitle:
                            Text('Quantity: ${menuItem['quantity'] ?? 0}'),
                        trailing: Text(
                            'Price: RM ${menuItem['price']?.toStringAsFixed(2) ?? 0.0}'),
                      );
                    },
                  ),
            const SizedBox(height: 16.0),
            Text(
              'Total Price: RM ${packagePrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _updateBooking,
              child: const Text('Save Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
