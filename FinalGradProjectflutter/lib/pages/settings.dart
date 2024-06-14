import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationsEnabled = true; // Define and initialize the variable
  String selectedLanguage =
      'English'; // Define and initialize the selected language

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Other settings widgets...
            Text(
              'Preferred Language:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                });
                // Update preferred language
              },
              items: <String>[
                'English',
                'Spanish',
                'French'
              ] // Add other languages if needed
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Other settings widgets...
            SizedBox(height: 20),
            Text(
              'Notification Settings:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Receive Notifications'),
              value: isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
                // Perform additional actions if needed
              },
            ),

            SizedBox(height: 20),
            Text(
              'Appearance Settings:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Theme Color: white'),
              onTap: () {
                // Change theme color
              },
            ),
            ListTile(
              title: Text('Font Size: Medium'),
              onTap: () {
                // Change font size
              },
            ),
          ],
        ),
      ),
    );
  }
}
