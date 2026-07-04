import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/components/item_card.dart';
import 'package:liquid_glass_widgets/widgets/shared/glass_page.dart';

class HomeContentPage extends StatefulWidget {
  final ValueNotifier<Map<String, Map<String, dynamic>>> cartNotifier;

  const HomeContentPage({super.key, required this.cartNotifier});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  final List<Map<String, dynamic>> cardInfo = [
    {'name': 'Espresso', 'price': 2.99},
    {'name': 'Americano', 'price': 3.49},
    {'name': 'Macchiato', 'price': 3.75},
    {'name': 'Cortado', 'price': 3.99},
    {'name': 'Cappuccino', 'price': 4.50},
    {'name': 'Latte', 'price': 4.75},
    {'name': 'Flat White', 'price': 4.50},
    {'name': 'Mocha', 'price': 5.25},
    {'name': 'Cold Brew', 'price': 4.25},
    {'name': 'Affogato', 'price': 5.50},
    {'name': 'Black Tea', 'price': 3.00},
    {'name': 'Earl Grey', 'price': 3.25},
    {'name': 'Green Tea', 'price': 3.25},
    {'name': 'Matcha Latte', 'price': 5.00},
    {'name': 'Oolong Tea', 'price': 3.75},
    {'name': 'White Tea', 'price': 3.50},
    {'name': 'Pu-erh Tea', 'price': 4.00},
    {'name': 'Masala Chai', 'price': 4.50},
    {'name': 'Chamomile Tea', 'price': 3.25},
    {'name': 'Rooibos Tea', 'price': 3.50},
  ];

  final List<Map<String, String>> cardData = [
    {'title': 'Free Delivery', 'image': 'assets/poster_home_page/delivery.png'},
    {
      'title': 'New seasonal drink',
      'image': 'assets/poster_home_page/new_drink.png',
    },
    {
      'title': 'Get 20% cashback',
      'image': 'assets/poster_home_page/cashback.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address', style: TextStyle(fontSize: 25)),
      ),
      body: GlassPage(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Special offers',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              CarouselSlider(
                options: CarouselOptions(
                  height: 140.0,
                  enlargeCenterPage: false,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {});
                  },
                ),
                items: cardData.map((data) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                            image: AssetImage(data['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap:
                      true, // Crucial so it doesn't fight with SingleChildScrollView
                  physics:
                      const NeverScrollableScrollPhysics(), // Let the parent scroll view handle scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cards per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing:
                        10, // Extra vertical space so floating counters don't overlap cards below
                    childAspectRatio: 0.85, // Adjust card height/width ratio
                  ),
                  itemCount: cardInfo.length,
                  itemBuilder: (context, index) {
                    final item = cardInfo[index];
                    return ItemCard(
                      name: item['name'],
                      price: item['price'],
                      cartNotifier: widget
                          .cartNotifier, // Pass down the central state notifier
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 120,
              ), // Extra space to clear the floating transparent bottom navigation bar
            ],
          ),
        ),
      ),
    );
  }
}
