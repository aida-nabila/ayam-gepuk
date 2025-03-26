import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/section_title.dart';
import '../../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'Guest'; // Default to 'Guest' if no user is logged in

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data on screen initialization
  }

  // Load the logged-in user's name from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'Guest'; // Fallback to 'Guest'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Column(
          children: [
            Text(
              "Welcome".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: primaryColor),
            ),
            Text(
              userName, // Display the logged-in user's name
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Image.asset(
                  'assets/images/banner.jpg',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  "About Ayam Gepuk",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: 8),
                child: Text(
                  "Ayam Gepuk is a popular Indonesian dish known for its tender fried chicken and signature spicy sambal. "
                  "We offer authentic flavors crafted with the finest ingredients. Whether you love it mild or extremely spicy, Ayam Gepuk has something for everyone!",
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
              const SizedBox(height: 20),
              SectionTitle(title: "Menu Highlights", press: () {}),
              const SizedBox(height: 16),
              ...List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                      defaultPadding, 0, defaultPadding, defaultPadding),
                  child: RestaurantInfoBigCard(
                    images: [
                      'assets/images/featured_items_1.jpg', // Replace with real images
                      'assets/images/featured_items_2.jpg',
                      'assets/images/featured_items_3.jpg'
                    ]..shuffle(),
                    name: "Ayam Gepuk - Special ${index + 1}",
                    rating: 4.5 + index * 0.1, // Dynamic rating
                    numOfRating: 100 + index * 50,
                    deliveryTime: 20 + index * 5,
                    foodType: const ["Spicy", "Authentic", "Indonesian"],
                    press: () {
                      // Navigate to menu details
                      Navigator.of(context).pushNamed('/menu');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
