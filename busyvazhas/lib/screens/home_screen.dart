import 'dart:developer';

import 'package:busyvazhas/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../providers/notification_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _startNotificationTimer();
  }



  void _startNotificationTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _generateRandomNotification();
        _startNotificationTimer();
      }
    });
  }

  void _generateRandomNotification() async {
    final platforms = ['Instagram', 'WhatsApp', 'Telegram'];
    final senders = ['John', 'Alice', 'Mom', 'Boss', 'Team'];
    final messages = [
      'liked your photo',
      'sent you a message',
      'shared a post with you',
      'mentioned you in a story'
    ];

    final random = DateTime.now().millisecondsSinceEpoch % 3;
    final platform = platforms[random];
    final sender =
        senders[DateTime.now().millisecondsSinceEpoch % senders.length];
    final message =
        messages[DateTime.now().millisecondsSinceEpoch % messages.length];
    log("random - $random && platform - $platform && sender - $sender && message - $message ");
    Icon icon;
    switch (platform) {
      case 'Instagram':
        icon = const Icon(Icons.favorite,color: Colors.blueAccent);
        break;
      case 'WhatsApp':
          icon = const Icon(Icons.messenger_outline_rounded,color: Colors.greenAccent);
        break;
      case 'Telegram':
          icon = const Icon(Icons.send_outlined,color: Colors.lightBlue);
        break;
      default:
          icon = const Icon(Icons.notifications_outlined,color: Colors.redAccent);
    }

    final notification = NotificationItem(
      platform: platform,
      sender: sender,
      message: message,
      timestamp: DateTime.now(),
      icon: icon,
    );

    Provider.of<NotificationProvider>(context, listen: false)
        .addNotification(notification);
    await NotificationService().showNotification(
        body: "hey there", title: "Hey there", payload: "heyyy");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusyVazhas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/customization'),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${notificationProvider.notificationCount} Notifications',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notificationProvider.notifications.length,
                  itemBuilder: (context, index) {
                    final notification =
                        notificationProvider.notifications[index];
                    return ListTile(
                      leading: notification.icon,
                      title: Text(
                        '${notification.sender} ${notification.message}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${notification.platform} • ${_formatTimestamp(notification.timestamp)}',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateRandomNotification,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
