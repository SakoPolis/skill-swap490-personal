import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// Screens
import 'screens/intro.dart';
import 'screens/browse.dart';
import 'screens/messages.dart';
import 'screens/profile_setup.dart';
import 'screens/request_swap.dart';
import 'screens/lesson_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---- Firebase init disabled until configured ----
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // } catch (e) {
  //   debugPrint('Firebase not configured yet: $e');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF38BDF8)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),

      // FIRST SCREEN:
      home: const IntroScreen(),

      // ROUTES:
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/browse': (context) => const BrowseScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/profile-setup': (context) => const ProfileSetupScreen(),
        '/request-swap': (context) => const RequestSwapScreen(),

        // Must include placeholder ID to satisfy constructor
        '/lesson-details': (context) =>
            const LessonDetailsScreen(id: 'placeholder'),
      },
    );
  }
}
