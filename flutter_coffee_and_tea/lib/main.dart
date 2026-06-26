import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_coffee_and_tea/components/splash_screen.dart';
import 'package:flutter_coffee_and_tea/firebase_options.dart';
import 'package:liquid_glass_widgets/liquid_glass_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://brgvzuyqcviiqzcolthl.supabase.co',
    // ignore: deprecated_member_use
    anonKey: 'sb_publishable_KJATVZv0X9ZQyytYU46EAg_EAVeDZRm',
  );

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(LiquidGlassWidgets.wrap(child: MyApp(showHome: showHome)));
}

class MyApp extends StatefulWidget {
  final bool showHome;

  const MyApp({super.key, required this.showHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee & Tea',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(showHome: widget.showHome),
    );
  }
}
