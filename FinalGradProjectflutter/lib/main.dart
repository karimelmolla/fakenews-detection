import 'package:first_project/pages/landing.dart';
import 'package:flutter/material.dart';
import 'package:first_project/pages/home.dart'; // Import your home page
import 'package:first_project/pages/settings.dart'; // Import your settings page
import 'package:first_project/pages/FAQ.dart'; // Import your FAQ page
import 'package:first_project/pages/contact_us.dart';
import 'package:first_project/pages/delete_account.dart';
import 'package:first_project/pages/feedback.dart';
import 'package:first_project/pages/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/landing': (context) => LandingPage(),
        '/settings': (context) => SettingsPage(),
        '/contact_us': (context) => ContactUsPage(),
        '/faq': (context) => FAQPage(),
        '/delete account': (context) => DeleteAccountPage(),
        '/Sign_Out': (context) => LandingPage(),
        '/feedback': (context) => FeedbackPage(),
        '/home': (context) => Home(),
      },
    );
  }
}
