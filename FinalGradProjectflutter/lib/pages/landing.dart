import 'package:first_project/pages/SignUp.dart';
import 'package:first_project/pages/login.dart';
import 'package:first_project/pages/Home.dart'; // Import the Home page
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _showUserGuide = true;

  void _hideOverlay() {
    setState(() {
      _showUserGuide = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40.0,
            right: 20.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return Home(); // Navigate to Home page
                  }),
                );
              },
              child: Text(
                "Skip for now",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Main content
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Factual ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Eye',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: Text(
                    "Your daily\nfact-checked news",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 60.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return SignUpPage(); // Navigate to sign-up page
                      }),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Material(
                      borderRadius: BorderRadius.circular(25),
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Log In',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return LogInPage(); // Navigate to log-in page
                              }),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          if (_showUserGuide) _buildUserGuideOverlay(context),
        ],
      ),
    );
  }

  Widget _buildUserGuideOverlay(BuildContext context) {
    return GestureDetector(
      onTap: _hideOverlay,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black54,
          child: Stack(
            children: [
              _buildGuideStep(
                context,
                "Step 1: Tap on get started to create your account",
                top: MediaQuery.of(context).size.height * 0.20,
                left: MediaQuery.of(context).size.width * 0.10,
                widget: Icon(Icons.smart_button_sharp,
                    size: 30, color: Colors.white),
              ),
              _buildGuideStep(
                context,
                "Step 2: Search for the article in any category that you need to detect",
                top: MediaQuery.of(context).size.height * 0.35,
                left: MediaQuery.of(context).size.width * 0.10,
                widget: Icon(Icons.search, size: 30, color: Colors.white),
              ),
              _buildGuideStep(
                context,
                "Step 3: Read the prediction and provide us with your feedback if needed",
                top: MediaQuery.of(context).size.height * 0.50,
                left: MediaQuery.of(context).size.width * 0.10,
                widget: Icon(Icons.feedback, size: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideStep(BuildContext context, String text,
      {required double top,
      double? left,
      double? right,
      required Widget widget}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget,
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}