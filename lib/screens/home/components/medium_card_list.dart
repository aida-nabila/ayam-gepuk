import 'package:flutter/material.dart';
import '../../../components/cards/medium/restaurant_info_medium_card.dart';
import '../../../components/scalton/medium_card_scalton.dart';
import '../../../constants.dart';
import '../../../demo_data.dart';

class MediumCardList extends StatefulWidget {
  const MediumCardList({super.key});

  @override
  State<MediumCardList> createState() => _MediumCardListState();
}

class _MediumCardListState extends State<MediumCardList> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        // Check if the widget is still in the widget tree
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // only for demo
    List data = demoMediumCardData..shuffle();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 254,
          child: isLoading
              ? buildFeaturedPartnersLoadingIndicator()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: (data.length - 1) == index ? defaultPadding : 0,
                    ),
                    child: RestaurantInfoMediumCard(
                      image: data[index]['image'],
                      name: data[index]['name'],
                      location: data[index]['location'],
                      delivertTime: 25,
                      rating: 4.6,
                      press: () {
                        // Trigger bottom navigation to navigate to MenuScreen
                        // Assuming EntryPoint handles navigation based on selected index
                        // Replace with your existing navigation structure
                        Navigator.of(context).pushNamed('/menu');
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  SingleChildScrollView buildFeaturedPartnersLoadingIndicator() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          2,
          (index) => const Padding(
            padding: EdgeInsets.only(left: defaultPadding),
            child: MediumCardScalton(),
          ),
        ),
      ),
    );
  }
}
