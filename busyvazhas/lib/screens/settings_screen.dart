import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/notification_provider.dart';
import '../providers/theme_provider.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool silentMode = false;
  bool showBadgeCount = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      silentMode = prefs.getBool('silentMode') ?? false;
      showBadgeCount = prefs.getBool('showBadgeCount') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
    await prefs.setBool('silentMode', silentMode);
    await prefs.setBool('showBadgeCount', showBadgeCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Enable dark theme'),
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(value);
                    });
                    _saveSettings();
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Silent Mode'),
                  subtitle: const Text('Mute notification sounds'),
                  value: silentMode,
                  onChanged: (value) {
                    setState(() {
                      silentMode = value;
                    });
                    _saveSettings();
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Show Badge Count'),
                  subtitle:
                      const Text('Display notification count on app icon'),
                  value: showBadgeCount,
                  onChanged: (value) {
                    setState(() {
                      showBadgeCount = value;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Clear All Notifications'),
                  subtitle: const Text('Reset notification count and history'),
                  trailing: const Icon(Icons.clear_all),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Notifications'),
                        content: const Text(
                            'Are you sure you want to clear all notifications?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<NotificationProvider>(context,
                                      listen: false)
                                  .clearNotifications();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Notifications cleared'),
                                ),
                              );
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  title: const Text('About BusyVazhas'),
                  subtitle: const Text('Version 1.0.0'),
                  trailing: const Icon(Icons.info_outline),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'BusyVazhas',
                      applicationVersion: '1.0.0',
                      applicationIcon: const FlutterLogo(size: 50),
                      children: const [
                        Text('Look busy, stay vazha.'),
                        SizedBox(height: 8),
                        Text(
                            'A fun app to make yourself look busy with fake notifications.'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
