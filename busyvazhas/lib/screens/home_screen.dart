import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider extends ChangeNotifier {
  int _notificationCount = 0;
  List<NotificationItem> _notifications = [];
  bool _endlessMode = false;

  int get notificationCount => _notificationCount;
  List<NotificationItem> get notifications => _notifications;
  bool get endlessMode => _endlessMode;

  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    _notificationCount++;
    notifyListeners();
  }

  void toggleEndlessMode(bool value) {
    _endlessMode = value;
    notifyListeners();
  }
}

class NotificationItem {
  final String platform;
  final String sender;
  final String message;
  final DateTime timestamp;
  final IconData icon;

  NotificationItem({
    required this.platform,
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.icon,
  });
}

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
    _initializeNotifications();
    _startNotificationTimer();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _startNotificationTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _generateRandomNotification();
        _startNotificationTimer();
      }
    });
  }

  void _generateRandomNotification() {
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
    final sender = senders[DateTime.now().millisecondsSinceEpoch % senders.length];
    final message =
        messages[DateTime.now().millisecondsSinceEpoch % messages.length];

    IconData icon;
    switch (platform) {
      case 'Instagram':
        icon = Icons.favorite;
        break;
      case 'WhatsApp':
        icon = Icons.chat_bubble;
        break;
      case 'Telegram':
        icon = Icons.send;
        break;
      default:
        icon = Icons.notifications;
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
    _showNotification(notification);
  }

  Future<void> _showNotification(NotificationItem notification) async {
    const androidDetails = AndroidNotificationDetails(
      'busy_vazhas_channel',
      'BusyVazhas Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.toInt(),
      notification.platform,
      '${notification.sender} ${notification.message}',
      details,
    );
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
                    final notification = notificationProvider.notifications[index];
                    return ListTile(
                      leading: Icon(
                        notification.icon,
                        color: Theme.of(context).primaryColor,
                      ),
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
