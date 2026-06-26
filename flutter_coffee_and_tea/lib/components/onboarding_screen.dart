import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/pages/auth_page.dart';
import 'package:flutter_coffee_and_tea/pages/onboarding_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  int currentPage = 0;
  final int totalPages = 3;

  String checkStr() {
    if (currentPage == 2) {
      return 'Get Started';
    }
    return 'Next';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          children: [
            OnboardingCards(
              controller: controller,
              currentPage: currentPage,
              imagePath: 'assets/page_1.png',
              text: 'Discover Your Perfect Brew',
            ),
            OnboardingCards(
              controller: controller,
              currentPage: currentPage,
              imagePath: 'assets/page_2.png',
              text: 'Your Favorites, Delivered',
            ),
            OnboardingCards(
              controller: controller,
              currentPage: currentPage,
              imagePath: 'assets/page_3.png',
              text: "Let's Get Started!",
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xffA77F60),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.2),
          //     blurRadius: 10,
          //     offset: const Offset(0, -2), // Pushes shadow upward
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Visibility(
              visible: currentPage != 0,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TextButton(
                onPressed: () {
                  controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text(
                  'Back',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  dotColor: Color.fromARGB(255, 193, 162, 105),
                  activeDotColor: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (currentPage == totalPages - 1) {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => AuthPage()),
                  );
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(
                checkStr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
