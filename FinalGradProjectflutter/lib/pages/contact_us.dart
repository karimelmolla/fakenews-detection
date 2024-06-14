import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email: Factual_eye@gmail.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone: +1234567890'),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Social Media: factual eye'),
            ),
            SizedBox(height: 10),
            Text(
              'Send us a message:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement submit functionality
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}