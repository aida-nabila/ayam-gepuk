import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/sign_in_screen.dart';
import '../booking_screen.dart';
import '../discount.dart';
import 'components/order_item_card.dart';
import 'components/price_row.dart';
import 'components/total_price.dart';

class OrderDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;

  const OrderDetailsScreen({
    super.key,
    required this.orderDetails,
  });

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late List<Map<String, dynamic>> localOrderDetails;
  String currentDiscountCode = ''; // Store the current discount code
  double discountPercentage = 0.0;
  bool isLoggedIn = false; // Track login status

  @override
  void initState() {
    super.initState();
    // Create a local copy of the order details
    localOrderDetails = List.from(widget.orderDetails);
    _checkLoginStatus();
  }

  // Check if the user is logged in
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

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

  // Apply discount logic
  void _applyDiscount(String discountCode) {
    setState(() {
      currentDiscountCode = discountCode;
      if (discountCode == 'DISCOUNT10') {
        discountPercentage = 10.0; // 10% discount
      } else if (discountCode == 'DISCOUNT20') {
        discountPercentage = 20.0; // 20% discount
      } else {
        discountPercentage = 0.0; // No discount
      }
    });
  }

  // Calculate the total price after applying discount
  double calculateTotalPrice() {
    double subtotal = localOrderDetails.fold(
      0.0,
      (sum, item) => sum + (item["price"] * item["quantity"]),
    );
    return subtotal - (subtotal * (discountPercentage / 100)); // Apply discount
  }

  @override
  Widget build(BuildContext context) {
    // Print the order details to debug
    print("Local OrderDetails: $localOrderDetails");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        automaticallyImplyLeading: false, // Removes the back button
        actions: [
          if (localOrderDetails.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.discount),
              onPressed: () async {
                // Navigate to DiscountPage to apply discount
                String appliedDiscountCode = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiscountPage(
                      onDiscountApplied: _applyDiscount,
                      currentDiscount: currentDiscountCode,
                    ),
                  ),
                );
                if (appliedDiscountCode.isNotEmpty) {
                  _applyDiscount(
                      appliedDiscountCode); // Apply discount if a code was entered
                }
              },
            ),
        ],
      ),
      body: isLoggedIn
          ? FutureBuilder<Map<String, String>>(
              future: _getUserData(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasData) {
                  return localOrderDetails.isNotEmpty
                      ? SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 16.0),
                                // Display each order item
                                ...List.generate(
                                  localOrderDetails.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: OrderedItemCard(
                                      title: localOrderDetails[index]["title"],
                                      description: localOrderDetails[index]
                                              ["description"] ??
                                          "",
                                      numOfItem: localOrderDetails[index]
                                          ["quantity"],
                                      price: localOrderDetails[index]["price"],
                                    ),
                                  ),
                                ),
                                PriceRow(
                                  text: "Subtotal",
                                  price: localOrderDetails.fold(
                                    0.0,
                                    (sum, item) =>
                                        sum +
                                        (item["price"] * item["quantity"]),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                if (discountPercentage > 0)
                                  PriceRow(
                                    text: "Discount",
                                    price: localOrderDetails.fold(
                                          0.0,
                                          (sum, item) =>
                                              sum +
                                              (item["price"] *
                                                  item["quantity"]),
                                        ) *
                                        (discountPercentage / 100),
                                  ),
                                const SizedBox(height: 8.0),
                                TotalPrice(
                                  price: calculateTotalPrice(),
                                ),
                                const SizedBox(height: 32.0),
                              ],
                            ),
                          ),
                        )
                      : const Center(child: Text("No orders found."));
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
                  child: const Text("Sign In to View Orders"),
                ),
              ),
            ),
      floatingActionButton: localOrderDetails.isNotEmpty && isLoggedIn
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to the booking screen only if the user is logged in
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(
                      selectedMenu: localOrderDetails.map((item) {
                        // Create a new map excluding the description
                        return {
                          'title': item['title'],
                          'quantity': item['quantity'],
                          'price': item['price'],
                        };
                      }).toList(), // Convert the iterable to a list
                      totalPrice: calculateTotalPrice(),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.book),
            )
          : null, // Show the button only when there are items in the order and the user is logged in
    );
  }
}
