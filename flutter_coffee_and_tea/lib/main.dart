import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/components/splash_screen.dart';
import 'package:flutter_coffee_and_tea/firebase_options.dart';
import 'package:flutter_coffee_and_tea/services/theme_service.dart';
import 'package:liquid_glass_widgets/liquid_glass_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Restore persisted theme before the first frame is drawn.
  await ThemeService.initialize();

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(LiquidGlassWidgets.wrap(child: MyApp(showHome: showHome)));
}

/// Cohesive Coffee & Tea Palette Definitions
const Color kPrimaryColor = Color(0xFFA77F60); // Warm Cocoa
const Color kSecondaryColor = Color(0xFFD4B296); // Creamy Latte Accent
const Color kLightBgColor = Color(0xFFFAF6F0); // Warm Milk Surface
const Color kDarkBgColor = Color(0xFF2C221A); // Deep Coffee Ground Surface
const Color kDarkCardColor = Color(
  0xFF3D3025,
); // Slightly lighter than Dark BG for depth
const Color kTextLightAccent = Color(
  0xFFF8F1E5,
); // Soft Cream for text readability

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Coffee & Tea',
          debugShowCheckedModeBanner: false,

          // --- LIGHT THEME ---
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: kLightBgColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: kPrimaryColor,
              primary: kPrimaryColor,
              secondary: kSecondaryColor,
              surface: kLightBgColor,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: kPrimaryColor,
              foregroundColor: kTextLightAccent,
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // --- DARK THEME ---
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: kDarkBgColor,
            cardColor: kDarkCardColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: kPrimaryColor,
              primary: kPrimaryColor,
              secondary: kSecondaryColor,
              surface: kDarkBgColor,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: kDarkCardColor,
              foregroundColor: kTextLightAccent,
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardThemeData(
              color: kDarkCardColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor:
                    kDarkBgColor, // Text is dark on a lighter button inside dark mode
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          themeMode: themeMode,
          home: SplashScreen(showHome: showHome),
        );
      },
    );
  }
}
