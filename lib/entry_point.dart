import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants.dart';
import 'screens/home/home_screen.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/orderDetails/order_details_screen.dart';
import 'screens/profile/profile_screen.dart';

class EntryPoint extends StatefulWidget {
  final int selectedTabIndex; // Add parameter to control the starting tab

  const EntryPoint(
      {super.key, this.selectedTabIndex = 0}); // Default to Home tab

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedTabIndex; // Use the passed tab index
  }

  Map<String, dynamic> selectedItems = {}; // Shared state for selected items

  final List<Map<String, dynamic>> _navitems = [
    {"icon": "assets/icons/home.svg", "title": "Home"},
    {"icon": "assets/icons/menu.svg", "title": "Menu"},
    {"icon": "assets/icons/order.svg", "title": "Orders"},
    {"icon": "assets/icons/profile.svg", "title": "Profile"},
  ];

  // Method to remove item (shared logic between Menu and Order screens)
  void _removeItem(String id, double price) {
    setState(() {
      if (selectedItems.containsKey(id)) {
        if (selectedItems[id]["quantity"] > 1) {
          selectedItems[id]["quantity"] -= 1;
        } else {
          selectedItems.remove(id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      MenuScreen(
        selectedItems: selectedItems, // Pass shared state to MenuScreen
        onOrderView: (items) {
          setState(() {
            selectedItems = items; // Update shared state
            _selectedIndex = 2; // Navigate to Orders tab
          });
        },
        onRemove: _removeItem, // Pass shared remove logic
      ),
      OrderDetailsScreen(
        orderDetails: selectedItems.entries.map((entry) {
          return {
            "title": entry.value["title"],
            "description": entry.value["description"],
            "price": entry.value["price"],
            "quantity": entry.value["quantity"],
          };
        }).toList(),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex], // Display the current screen
      bottomNavigationBar: CupertinoTabBar(
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        currentIndex: _selectedIndex,
        activeColor: primaryColor,
        inactiveColor: bodyTextColor,
        items: List.generate(
          _navitems.length,
          (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _navitems[index]["icon"],
              height: 30,
              width: 30,
              colorFilter: ColorFilter.mode(
                  index == _selectedIndex ? primaryColor : bodyTextColor,
                  BlendMode.srcIn),
            ),
            label: _navitems[index]["title"],
          ),
        ),
      ),
    );
  }
}
