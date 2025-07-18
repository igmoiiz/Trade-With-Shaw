// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Trade Executed',
      'body': 'Your EUR/USD trade was executed successfully.',
      'time': 'Just now',
    },
    {
      'title': 'New Signal',
      'body': 'A new premium signal is available.',
      'time': '1 hour ago',
    },
    {
      'title': 'Subscription Expiring',
      'body': 'Your premium subscription expires in 3 days.',
      'time': 'Yesterday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child:
              notifications.isEmpty
                  ? Center(
                    child: Text(
                      'No notifications',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white54),
                    ),
                  )
                  : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return Dismissible(
                        key: ValueKey(item['title']! + item['time']!),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          setState(() => notifications.removeAt(index));
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        child: _GlassNotificationCard(
                          title: item['title']!,
                          body: item['body']!,
                          time: item['time']!,
                          icon: _getIcon(item['title']!),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }

  IconData _getIcon(String title) {
    if (title.contains('Trade')) return Icons.show_chart_rounded;
    if (title.contains('Signal')) return Icons.notifications_active_rounded;
    if (title.contains('Subscription')) return Icons.verified_user_rounded;
    return Icons.notifications_rounded;
  }
}

class _GlassNotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final IconData icon;

  const _GlassNotificationCard({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                width: 1.1,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(icon, color: Colors.black),
              ),
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ),
              trailing: Text(
                time,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
