import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import 'home_screen.dart';

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  bool instagramEnabled = true;
  bool whatsappEnabled = true;
  bool telegramEnabled = true;
  String selectedTheme = 'CEO';
  double notificationFrequency = 3.0;
  bool endlessMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customization'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Platform Selection',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Instagram'),
                    secondary: const Icon(Icons.camera_alt),
                    value: instagramEnabled,
                    onChanged: (value) {
                      setState(() {
                        instagramEnabled = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('WhatsApp'),
                    secondary: const Icon(Icons.chat),
                    value: whatsappEnabled,
                    onChanged: (value) {
                      setState(() {
                        whatsappEnabled = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Telegram'),
                    secondary: const Icon(Icons.send),
                    value: telegramEnabled,
                    onChanged: (value) {
                      setState(() {
                        telegramEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pretend Mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedTheme,
                    decoration: const InputDecoration(
                      labelText: 'Select Theme',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'CEO',
                        child: Text('CEO'),
                      ),
                      DropdownMenuItem(
                        value: 'Influencer',
                        child: Text('Influencer'),
                      ),
                      DropdownMenuItem(
                        value: 'Busy Friend',
                        child: Text('Busy Friend'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedTheme = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Notification Frequency (seconds)'),
                  Slider(
                    value: notificationFrequency,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: notificationFrequency.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        notificationFrequency = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Endless Mode'),
                    subtitle: const Text(
                      'Keep notifications coming automatically',
                    ),
                    value: endlessMode,
                    onChanged: (value) {
                      setState(() {
                        endlessMode = value;
                      });
                      Provider.of<NotificationProvider>(context, listen: false)
                          .toggleEndlessMode(value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
