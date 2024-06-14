import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0;
  List<String> _improvementAreas = [];
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() {
    // Logic to handle feedback submission, e.g., send to a server
    print('Rating: $_rating');
    print('Improvement Areas: $_improvementAreas');
    print('Feedback: ${_feedbackController.text}');
    // Show thank you screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Thank you!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'By making your voice heard, you help us improve Factual Eye.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close feedback page
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
    // Clear form after submission
    setState(() {
      _rating = 0;
      _improvementAreas.clear();
      _feedbackController.clear();
    });
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        _rating >= index ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 36.0,
      ),
      onPressed: () {
        setState(() {
          _rating = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We appreciate your feedback.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We are always looking for ways to improve your experience. Please take a moment to evaluate and tell us what you think.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Rate Your Experience',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) => _buildStar(index + 1)),
            ),
            SizedBox(height: 20),
            Text(
              'Tell us what can be improved?',
              style: TextStyle(fontSize: 16),
            ),
            Wrap(
              spacing: 8.0,
              children: [
                'Overall Service',
                'Customer Support',
                'Speed',
                'Content Accuracy',
                'User Interface',
                'Notification Quality',
                'Feature Request',
                'Transparency',
              ].map((area) {
                return FilterChip(
                  label: Text(area),
                  selected: _improvementAreas.contains(area),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _improvementAreas.add(area);
                      } else {
                        _improvementAreas.remove(area);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tell us how can we improve...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}