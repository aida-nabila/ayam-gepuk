import 'package:ayamgepuk/entry_point.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

import '../../components/dot_indicators.dart';
import 'components/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  illustration: demoData[index]["illustration"],
                  title: demoData[index]["title"],
                  text: demoData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EntryPoint(),
                    ),
                  );
                },
                child: Text("Get Started".toUpperCase()),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// Demo data for our Onboarding screen
List<Map<String, dynamic>> demoData = [
  {
    "illustration": "assets/Illustrations/Illustrations_1.svg",
    "title": "Book Your Ayam Gepuk Experience",
    "text":
        "Craving Ayam Gepuk? Book a table at your favorite spot\nand enjoy a delicious, crispy meal fresh from the kitchen.",
  },
  {
    "illustration": "assets/Illustrations/Illustrations_2.svg",
    "title": "Satisfy Your Hunger",
    "text": "Craving the best Ayam Gepuk? \n We’ve got you covered!",
  },
  {
    "illustration": "assets/Illustrations/Illustrations_3.svg",
    "title": "Taste the Tradition",
    "text": "Delicious, crispy, and full of flavor \n — Ayam Gepuk made right!",
  },
];
