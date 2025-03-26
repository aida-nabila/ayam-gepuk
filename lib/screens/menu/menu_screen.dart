import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/items.dart';

class MenuScreen extends StatefulWidget {
  final Map<String, dynamic> selectedItems;
  final Function(Map<String, dynamic>) onOrderView;
  final Function(String, double) onRemove;
  final bool isForEditBooking;

  const MenuScreen({
    super.key,
    required this.selectedItems,
    required this.onOrderView,
    required this.onRemove,
    this.isForEditBooking = false,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  double totalPrice = 0.0;
  late Map<String, dynamic> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = Map<String, dynamic>.from(widget.selectedItems);
    print("Initial selectedItems: $selectedItems");
    print("isForEditBooking in MenuScreen: ${widget.isForEditBooking}");
    updateTotalPrice();
  }

  void updateTotalPrice() {
    double total = 0.0;
    selectedItems.forEach((key, value) {
      total += (value["price"] ?? 0) * (value["quantity"] ?? 0);
    });
    setState(() {
      totalPrice = total;
      print("Total price updated: $totalPrice");
    });
  }

  void addItem(String id, String title, String description, double price) {
    setState(() {
      if (selectedItems.containsKey(id)) {
        selectedItems[id]["quantity"] += 1;
      } else {
        selectedItems[id] = {
          "title": title,
          "description": description,
          "price": price,
          "quantity": 1,
        };
      }
      print("Item added: $id, updated selectedItems: $selectedItems");
      updateTotalPrice();
    });
  }

  void removeItem(String id, double price) {
    setState(() {
      if (selectedItems.containsKey(id)) {
        if (selectedItems[id]["quantity"] > 1) {
          selectedItems[id]["quantity"] -= 1;
        } else {
          selectedItems.remove(id);
        }
      }
      widget.onRemove(id, price);
      print("Item removed: $id, updated selectedItems: $selectedItems");
      updateTotalPrice();
    });
  }

  void handleViewOrder() {
    print("Button clicked!");
    print("isForEditBooking: ${widget.isForEditBooking}");
    print("Selected Items: $selectedItems");
    print("Total Price: $totalPrice");

    if (selectedItems.isEmpty) {
      print("No items in the order!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No items in your order! Please add items."),
        ),
      );
      return;
    }

    if (widget.isForEditBooking) {
      Navigator.pop(context, selectedItems);
    } else {
      widget.onOrderView(selectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isForEditBooking ? "Edit Booking" : "Menu"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: defaultPadding / 2),
                  const SizedBox(height: defaultPadding),
                  Items(
                    onAdd: addItem,
                    onRemove: removeItem,
                    quantities: {
                      for (var entry in selectedItems.entries)
                        entry.key: entry.value["quantity"] ?? 0
                    },
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                height: 80.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: handleViewOrder,
                        child: Text(
                          widget.isForEditBooking
                              ? "Update Order (RM ${totalPrice.toStringAsFixed(2)})"
                              : "View Order (RM ${totalPrice.toStringAsFixed(2)})",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
