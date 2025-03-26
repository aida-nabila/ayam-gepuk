import 'package:flutter/material.dart';
import '../../constants.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final double ratings; // Added ratings property
  final double price;
  final VoidCallback press;
  final VoidCallback increasePress;
  final VoidCallback decreasePress;
  final int quantity; // Add quantity parameter to track the count

  const ItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.ratings, // Initialize ratings
    required this.price,
    required this.press,
    required this.increasePress,
    required this.decreasePress,
    required this.quantity, // Initialize the quantity
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 131,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        Text(
                          ratings.toStringAsFixed(1),
                          style: const TextStyle(color: titleColor),
                        ),
                        const Spacer(),
                        Text(
                          "RM${price.toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: primaryColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: decreasePress,
                        ),
                        // Display quantity between buttons
                        Text(
                          '$quantity',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: increasePress,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
