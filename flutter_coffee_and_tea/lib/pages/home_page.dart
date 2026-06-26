import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/pages/page_controller/home_content_page.dart';
import 'package:flutter_coffee_and_tea/pages/page_controller/orders_page.dart';
import 'package:flutter_coffee_and_tea/pages/page_controller/profile.dart';
import 'package:flutter_coffee_and_tea/pages/page_controller/search.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  // 1. Define the central cart notifier matching your ItemCard map structure
  final ValueNotifier<Map<String, Map<String, dynamic>>> _cartNotifier =
      ValueNotifier<Map<String, Map<String, dynamic>>>({});

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cartNotifier.dispose(); // Good practice to clean up memory resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: Colors.white,
      body: GlassPage(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            HomeContentPage(cartNotifier: _cartNotifier,),
            SearchPage(),
            OrdersPage(cartNotifier: _cartNotifier),
            ProfilePage(),
          ],
        ),
      ),

      bottomNavigationBar: GlassBottomBar(
        selectedIconColor: const Color(0xff8A5F41),
        unselectedIconColor: const Color(0xffA77F60),
        settings: LiquidGlassSettings(glassColor: Colors.white),
        enableBlend: false,
        interactionGlowRadius: 0,
        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          FocusScope.of(context).unfocus();
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          );
        },
        quality: GlassQuality.minimal,
        tabs: [
          GlassBottomBarTab(
            label: 'Home',
            icon: const Icon(Icons.home_rounded),
          ),
          GlassBottomBarTab(
            label: 'Search',
            icon: const Icon(Icons.search_rounded),
          ),
          GlassBottomBarTab(
            label: 'Orders',
            // 3. Listen to cart changes to dynamically calculate total quantities for your badge
            icon: ValueListenableBuilder<Map<String, Map<String, dynamic>>>(
              valueListenable: _cartNotifier,
              builder: (context, cartMap, child) {
                // Loop through your map collection and sum all item ['quantity'] properties
                int totalItems = cartMap.values.fold(
                  0,
                  (sum, itemInfo) => sum + (itemInfo['quantity'] as int? ?? 0),
                );
                return Stack(
                  clipBehavior: Clip.none, 
                  children: [
                    const Icon(Icons.receipt_rounded),
                    // Only render badge overlay if there's actually items in the user's cart
                    if (totalItems > 0)
                      Positioned(
                        right: -4, 
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$totalItems',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          GlassBottomBarTab(
            label: 'Profile',
            icon: const Icon(Icons.person_rounded),
          ),
        ],
      ),
    );
  }
}