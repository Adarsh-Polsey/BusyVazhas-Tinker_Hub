import 'package:flutter/material.dart';

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

class NotificationProvider extends ChangeNotifier {
  List<NotificationItem> _notifications = [];
  int _notificationCount = 0;
  bool _endlessMode = true;
  
  // Platform toggles
  bool _instagramEnabled = true;
  bool _whatsAppEnabled = true;
  bool _telegramEnabled = true;
  
  // Getters
  List<NotificationItem> get notifications => _notifications;
  int get notificationCount => _notificationCount;
  bool get endlessMode => _endlessMode;
  
  bool get instagramEnabled => _instagramEnabled;
  bool get whatsAppEnabled => _whatsAppEnabled;
  bool get telegramEnabled => _telegramEnabled;

  // Add Notification
  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    _notificationCount++;
    notifyListeners();
  }

  // Clear all notifications
  void clearNotifications() {
    _notifications.clear();
    _notificationCount = 0;
    notifyListeners();
  }

  // Toggle Endless Mode
  void toggleEndlessMode(bool value) {
    _endlessMode = value;
    notifyListeners();
  }

  // Toggle Platform Notifications
  void togglePlatform(String platform, bool value) {
    switch (platform) {
      case 'Instagram':
        _instagramEnabled = value;
        break;
      case 'WhatsApp':
        _whatsAppEnabled = value;
        break;
      case 'Telegram':
        _telegramEnabled = value;
        break;
    }
    notifyListeners();
  }

  // Generate Random Notification
  NotificationItem generateRandomNotification() {
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
    
    // Respect platform toggles
    if ((platform == 'Instagram' && !_instagramEnabled) ||
        (platform == 'WhatsApp' && !_whatsAppEnabled) ||
        (platform == 'Telegram' && !_telegramEnabled)) {
      return generateRandomNotification(); // Recursive call to get an enabled platform
    }

    final sender = senders[DateTime.now().millisecondsSinceEpoch % senders.length];
    final message = messages[DateTime.now().millisecondsSinceEpoch % messages.length];

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

    return NotificationItem(
      platform: platform,
      sender: sender,
      message: message,
      timestamp: DateTime.now(),
      icon: icon,
    );
  }
}
