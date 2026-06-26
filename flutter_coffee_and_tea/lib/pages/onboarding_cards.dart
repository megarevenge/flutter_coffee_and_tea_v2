import 'package:flutter/material.dart';

class OnboardingCards extends StatefulWidget {
  final PageController controller;
  final int currentPage;
  final String imagePath;
  final String text; 

  const OnboardingCards({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.imagePath,
    required this.text,
  });

  @override
  State<OnboardingCards> createState() => _OnboardingCardsState();
}

class _OnboardingCardsState extends State<OnboardingCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
            ),
          ),

          // 2. Foreground Content (Skip button + Centered Text)
          SafeArea(
            child: SizedBox.expand( // Ensures the column stretches across the full width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontal children
                children: [
                  // Row to keep Skip button on the far right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: Visibility(
                          visible: widget.currentPage != 2,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: TextButton(
                            onPressed: () {
                              widget.controller.animateToPage(
                                2,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xff8A5F41),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Space between the Skip button and your text
                  const SizedBox(height: 10), 

                  // 3. Your Centered Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8A5F41),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}