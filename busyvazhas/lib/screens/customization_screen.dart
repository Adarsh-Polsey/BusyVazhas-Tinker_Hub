import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';

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
                        Provider.of<NotificationProvider>(context,
                                listen: false)
                            .togglePlatform('Instagram', value);
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
                        Provider.of<NotificationProvider>(context,
                                listen: false)
                            .togglePlatform('WhatsApp', value);
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
                        Provider.of<NotificationProvider>(context,
                                listen: false)
                            .togglePlatform('Telegram', value);
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
        ],
      ),
    );
  }
}
