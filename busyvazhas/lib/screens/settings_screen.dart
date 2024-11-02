import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/notification_provider.dart';
import '../providers/theme_provider.dart';

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
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
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
                  title: const Text('Dark Vibe'),
                  subtitle: const Text('Iruttaakkam, athalle rasam'),
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
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card(
          //   margin: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Column(
          //     children: [
          //       ListTile(
          //         title: const Text('Customize'),
          //         subtitle: const Text('Customize cheyyam'),
          //         trailing: const Icon(Icons.clear_all),
          //         onTap: () {
          //           Navigator.pushNamed(context, '/customization');
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Clear All Notifications'),
                  subtitle: const Text('Ozhivakk'),
                  trailing: const Icon(Icons.clear_all),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Notifications'),
                        content: const Text('Suree??'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Nopee'),
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
                            child: const Text('Yep'),
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
                  subtitle: const Text('Busy vazhas nn paranjaa......'),
                  trailing: const Icon(Icons.info_outline),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'BusyVazhas',
                      applicationVersion:
                          'anganonnullyaa, ellam anganokke thanne',
                      applicationIcon: const FlutterLogo(size: 50),
                      children: const [
                        Text('Look busy, stay vazha.'),
                        SizedBox(height: 8),
                        Text('Vellyaa sambhavann kanich kodkkaa'),
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
