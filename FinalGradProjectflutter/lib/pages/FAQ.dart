import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('What is Factual eye ?'),
              subtitle: Text(
                  'Factual Eye is a free mobile application designed to help users identify and avoid fake news and misinformation. '),
            ),
            ListTile(
              title: Text('How does Factual Eye detect fake news?'),
              subtitle: Text(
                  'Factual Eye employs a combination of artificial intelligence, natural language processing, and machine learning algorithms to assess the credibility of news articles.'),
            ),
            ListTile(
                title: Text('Is Factual Eye reliable?'),
                subtitle: Text(
                    'Yes, Factual Eye is committed to providing reliable information, but users should always critically evaluate the news they encounter.')),
            ListTile(
              title: Text(
                  'Is my personal information safe when using Factual Eye?'),
              subtitle: Text(
                  'Yes, Factual Eye prioritizes user privacy and does not collect or store personally identifiable information without explicit consent.'),
            ),
          ],
        ),
      ),
    );
  }
}
