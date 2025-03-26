import 'package:flutter/material.dart';
import '../../../components/cards/item_card.dart';
import '../../../constants.dart';
import '../../addToOrder/add_to_order_screen.dart';

class Items extends StatelessWidget {
  final void Function(String id, String title, String description, double price)
      onAdd;
  final void Function(String id, double price) onRemove;
  final Map<String, int> quantities;

  const Items({
    super.key,
    required this.onAdd,
    required this.onRemove,
    required this.quantities,
  });

  Widget _buildItemCard(
    BuildContext context,
    String id,
    String title,
    String description,
    double price,
    String image,
  ) {
    // Debugging to verify quantities being passed
    print("Building card for $id with quantity: ${quantities[id] ?? 0}");
    return ItemCard(
      title: title,
      description: description,
      image: image,
      ratings: 4.5,
      price: price,
      press: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddToOrderScreen(
              id: id,
              title: title,
              description: description,
              price: price,
              image: image,
            ),
          ),
        );
      },
      increasePress: () => onAdd(id, title, description, price),
      decreasePress: () {
        if ((quantities[id] ?? 0) > 0) {
          onRemove(id, price);
        }
      }, // Only call onRemove if quantity > 0
      quantity: quantities[id] ?? 0, // Set the passed quantity or default to 0
    );
  }

  @override
  Widget build(BuildContext context) {
    // Debugging to verify quantities
    print("Quantities passed to Items widget: $quantities");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTabController(
          length: demoTabs.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                unselectedLabelColor: titleColor,
                labelStyle: Theme.of(context).textTheme.titleLarge,
                tabs: demoTabs,
              ),
              SizedBox(
                height: 680,
                child: TabBarView(
                  children: [
                    // Most Populars Tab
                    Column(
                      children: [
                        _buildItemCard(
                          context,
                          "Ayam Gepuk Set A", // Matching key for quantity
                          "Ayam Gepuk Set A",
                          "A delicious plate of spicy fried chicken served with a side of steamed rice, sambal, savory soy sauce, and fresh vegetables.",
                          10.0,
                          "assets/images/featured_items_1.jpg",
                        ),
                        const SizedBox(height: defaultPadding),
                        _buildItemCard(
                          context,
                          "Ayam Gepuk Set B", // Matching key for quantity
                          "Ayam Gepuk Set B",
                          "A hearty serving of fried chicken with a side of steamed rice, sambal, savory soy sauce, crispy tempe, fried tofu, and fresh vegetables.",
                          11.0,
                          "assets/images/featured_items_2.jpg",
                        ),
                      ],
                    ),
                    // Set Ayam Tab
                    Column(
                      children: [
                        _buildItemCard(
                          context,
                          "Ayam Gepuk Set A",
                          "Ayam Gepuk Set A",
                          "A delicious plate of spicy fried chicken served with a side of steamed rice, sambal, savory soy sauce, and fresh vegetables.",
                          10.0,
                          "assets/images/featured_items_1.jpg",
                        ),
                        const SizedBox(height: defaultPadding),
                        _buildItemCard(
                          context,
                          "Ayam Gepuk Set B",
                          "Ayam Gepuk Set B",
                          "A hearty serving of fried chicken with a side of steamed rice, sambal, savory soy sauce, crispy tempe, fried tofu, and fresh vegetables.",
                          11.0,
                          "assets/images/featured_items_2.jpg",
                        ),
                        _buildItemCard(
                          context,
                          "Ayam Gepuk Set C",
                          "Ayam Gepuk Set C",
                          "A satisfying meal of crispy fried chicken, paired with steamed rice, sambal, savory soy sauce, crispy tempeh, golden fried tofu, tender gizzards and a selection of fresh vegetables.",
                          12.0,
                          "assets/images/featured_items_3.jpg",
                        ),
                        _buildItemCard(
                          context,
                          "Ayam Gepuk Set D",
                          "Ayam Gepuk Set D",
                          "A generous plate featuring crispy fried chicken, served with steamed rice, sambal, savory soy sauce, crunchy tempeh, golden fried tofu, fried cabbage, tender gizzards, and a medley of fresh vegetables.",
                          13.0,
                          "assets/images/featured_items_4.jpg",
                        ),
                      ],
                    ),
                    // Set Ikan Tab
                    Column(
                      children: [
                        _buildItemCard(
                          context,
                          "Talapia Set",
                          "Talapia Set",
                          "Crispy fried talapia served with steamed rice, sambal, savory soy sauce, and fresh vegetables.",
                          12.0,
                          "assets/images/featured_items_5.jpg",
                        ),
                        const SizedBox(height: defaultPadding),
                        _buildItemCard(
                          context,
                          "Keli Set",
                          "Keli Set",
                          "Grilled catfish served with steamed rice, sambal, soy sauce, and fresh vegetables.",
                          9.0,
                          "assets/images/featured_items_6.jpg",
                        ),
                      ],
                    ),
                    // Drinks Tab
                    Column(
                      children: [
                        _buildItemCard(
                          context,
                          "Iced Lemon Tea",
                          "Iced Lemon Tea",
                          "A chilled, tangy tea infused with zesty lemon for a refreshing sip.",
                          4.2,
                          "assets/images/air1.png",
                        ),
                        const SizedBox(height: defaultPadding),
                        _buildItemCard(
                          context,
                          "Orange Soda",
                          "Orange Soda",
                          "A fizzy, citrusy refreshment bursting with sweet orange flavor.",
                          3.5,
                          "assets/images/air2.png",
                        ),
                        const SizedBox(height: defaultPadding),
                        _buildItemCard(
                          context,
                          "Honeydew Latte",
                          "Honeydew Latte",
                          "A creamy, sweet blend of honeydew and milk for a delightful twist.",
                          5.8,
                          "assets/images/air3.png",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final List<Tab> demoTabs = <Tab>[
  const Tab(child: Text('Most Populars')),
  const Tab(child: Text('Set Ayam')),
  const Tab(child: Text('Set Ikan')),
  const Tab(child: Text('Drinks')),
];
