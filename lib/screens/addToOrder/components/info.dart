import 'package:flutter/material.dart';
import '../../../constants.dart';

// Info widget now receives dynamic data from the `AddToOrderScrreen`
class Info extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final double price;

  const Info({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.33,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text("Price: RM${price.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
