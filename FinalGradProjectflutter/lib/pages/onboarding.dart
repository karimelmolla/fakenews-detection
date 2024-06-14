import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _navigateToLanding() {
    Navigator.of(context).pushReplacementNamed('/landing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: <Widget>[
              OnboardingPage(
                icon: Icons.search_outlined,
                title: "Is it real or fake?",
                subtitle:
                    "Identify fake news instantly with Factual Eye using advanced machine learning algorithms.",
                backgroundColor: Color.fromARGB(255, 5, 82, 130),
                textColor: Colors.white,
                onNext: () => _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                onSkip: _navigateToLanding,
                additionalInfo: [
                  "Real-time analysis of news articles to determine authenticity.",
                  "Uses a combination of natural language processing and machine learning.",
                  "Provides reliability scores for each news source."
                ],
              ),
              OnboardingPage(
                icon: Icons.fact_check,
                title: "Your reliable news companion.",
                subtitle:
                    "Get fact-checked news at your fingertips with comprehensive source analysis.",
                backgroundColor: Color.fromARGB(255, 5, 82, 130),
                textColor: Colors.white,
                onNext: () => _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                onSkip: _navigateToLanding,
                additionalInfo: [
                  "Aggregates news from trusted sources worldwide.",
                  "Offers detailed reports on news credibility.",
                  "Keeps you informed with unbiased, fact-checked news."
                ],
              ),
              OnboardingPage(
                icon: Icons.accessibility,
                title: "Stay informed.",
                subtitle:
                    "Stay informed with Factual Eye, accessible anywhere, anytime, on any device.",
                backgroundColor: Color.fromARGB(255, 5, 82, 130),
                textColor: Colors.white,
                onNext: _navigateToLanding,
                onSkip: _navigateToLanding,
                additionalInfo: [
                  "Access news from your device seamlessly.",
                  "Choose your preferred categories ",
                  "Receive instant notifications for breaking news and updates."
                ],
              ),
            ],
          ),
          Positioned(
            top: 40.0,
            right: 20.0,
            child: GestureDetector(
              onTap: _navigateToLanding,
              child: Text(
                "Skip for now",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final List<String> additionalInfo;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    required this.onNext,
    required this.onSkip,
    required this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Icon(icon, size: 100, color: textColor),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              subtitle,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            for (var info in additionalInfo)
              Text(
                info,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            Spacer(),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                "Next",
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: onSkip,
              child: Text(
                "Skip",
                style: TextStyle(color: textColor),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}