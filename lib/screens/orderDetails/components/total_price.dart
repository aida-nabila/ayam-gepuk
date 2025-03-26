import 'package:flutter/material.dart';

import '../../../constants.dart';

class TotalPrice extends StatelessWidget {
  const TotalPrice({
    super.key,
    required this.price,
  });

  final double price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text.rich(
          TextSpan(
            text: "Total ",
            style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          "RM$price",
          style:
              const TextStyle(color: titleColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
