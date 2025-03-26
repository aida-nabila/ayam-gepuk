import 'package:flutter/material.dart';

class DiscountPage extends StatefulWidget {
  final Function(String) onDiscountApplied;
  final String currentDiscount; // Store the current discount

  const DiscountPage(
      {super.key,
      required this.onDiscountApplied,
      required this.currentDiscount});

  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final TextEditingController _discountController = TextEditingController();
  final Map<String, double> discountCodes = {
    'DISCOUNT10': 0.10,
    'DISCOUNT20': 0.20,
  };

  String errorMessage = '';
  bool isValidDiscount = false;
  bool discountApplied = false; // Track whether discount is applied

  @override
  void initState() {
    super.initState();
    // Check if current discount is valid at the start
    if (discountCodes.containsKey(widget.currentDiscount)) {
      isValidDiscount = true;
      discountApplied = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Apply Discount")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Available Discount Codes:"),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: discountCodes.length,
              itemBuilder: (context, index) {
                String code = discountCodes.keys.elementAt(index);
                double value = discountCodes[code]!;
                bool isApplied = widget.currentDiscount == code;
                return ListTile(
                  title: Text(code),
                  subtitle: Text("Discount: ${value * 100}%"),
                  trailing: TextButton(
                    onPressed: isApplied
                        ? () {
                            widget.onDiscountApplied(""); // Remove the discount
                            Navigator.pop(
                                context); // Go back to the order summary
                          }
                        : () {
                            widget.onDiscountApplied(code); // Apply discount
                            Navigator.pop(
                                context); // Go back to the order summary
                          },
                    child: Text(
                      isApplied ? 'Remove' : 'Apply',
                      style: TextStyle(
                        color: isApplied
                            ? Colors.red // Red for "Remove" button
                            : null, // Default for "Apply" button
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _discountController,
              decoration: InputDecoration(
                labelText: "Enter discount code",
                border: const OutlineInputBorder(),
                suffixIcon:
                    _discountController.text.isNotEmpty && !isValidDiscount
                        ? const Icon(Icons.error, color: Colors.red)
                        : null, // Show error symbol only when incorrect
              ),
              onChanged: (value) {
                String enteredCode = value.trim().toUpperCase();
                setState(() {
                  if (discountCodes.containsKey(enteredCode)) {
                    isValidDiscount = true;
                    errorMessage = ''; // Clear error if valid
                  } else {
                    isValidDiscount = false;
                    errorMessage = 'Invalid discount code.';
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String enteredCode = _discountController.text.toUpperCase();
                if (discountCodes.containsKey(enteredCode)) {
                  widget.onDiscountApplied(enteredCode);
                  Navigator.pop(context);
                } else {
                  setState(() {
                    errorMessage = 'Invalid discount code!';
                  });
                }
              },
              child: const Text('Apply'),
            ),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
