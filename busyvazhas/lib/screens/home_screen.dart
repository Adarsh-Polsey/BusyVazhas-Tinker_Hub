import 'dart:developer';

import 'package:busyvazhas/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  bool timerStatus = true;
  @override
  void initState() {
    super.initState();
    _startNotificationTimer();
  }

  void _startNotificationTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && timerStatus) {
        _generateRandomNotification();
        _startNotificationTimer();
      }
    });
  }

  void _generateRandomNotification() async {
    final platforms = ['Instagram', 'WhatsApp', 'Telegram'];
    final senders = [
      'Ayush',
      'Emily Willys',
      'Bennychan',
      'Maman',
      'Boss',
      'Team'
    ];
    final messages = [
      'vaishanavinu pennu kittyyydaaa ',
      'vaveee fd  kazhichoooo',
      'Nammakk onn koodande🍻',
      'Suganoo🫦',
      'Daa Matte video kittyooo'
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
        icon = const Icon(Icons.favorite, color: Colors.blueAccent);
        break;
      case 'WhatsApp':
        icon = const Icon(Icons.messenger_outline_rounded,
            color: Colors.greenAccent);
        break;
      case 'Telegram':
        icon = const Icon(Icons.send_outlined, color: Colors.lightBlue);
        break;
      default:
        icon =
            const Icon(Icons.notifications_outlined, color: Colors.redAccent);
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
    await NotificationService().showNotification(notification: notification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUSY-VAZHAAS'),
        actions: [
          GestureDetector(
              onTap: () {
                setState(() {});
                timerStatus = !timerStatus;
                _startNotificationTimer();
              },
              child: LottieBuilder.asset(
                height: 50,
                width: 50,
                animate: true,
                repeat: false,
                timerStatus == false
                    ? 'assets/animations/notification-bell-disabled.json'
                    : 'assets/animations/notification-bell.json',
              )),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: LottieBuilder.asset(
                height: 50,
                width: 50,
                animate: true,
                repeat: false,
                'assets/animations/settings.json',
              )),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          return Column(
            children: [
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
