import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Liste simulée avec des sections de date
  List<Map<String, dynamic>> _notifications = [
    {
      "id": "1",
      "dateSection": "AUJOURD'HUI",
      "title": "Rappel de Loyer",
      "body": "Votre loyer de Décembre (50.000 F) arrive à échéance.",
      "time": "Il y a 2h",
      "type": "warning",
      "isUnread": true,
    },
    {
      "id": "2",
      "dateSection": "AUJOURD'HUI",
      "title": "Nouveau Message",
      "body": "Le gestionnaire a répondu à votre ticket #204.",
      "time": "09:15",
      "type": "info",
      "isUnread": true,
    },
    {
      "id": "3",
      "dateSection": "HIER",
      "title": "Maintenance Validée",
      "body": "Le plombier passera ce jeudi à 14h.",
      "time": "16:45",
      "type": "success",
      "isUnread": false,
    },
    {
      "id": "4",
      "dateSection": "HIER",
      "title": "Reçu Disponible",
      "body": "Votre quittance de Novembre est disponible.",
      "time": "08:00",
      "type": "document",
      "isUnread": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // On groupe les notifications par date pour l'affichage
    final groupedNotifications = _groupNotifications();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F6F9),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.darkBlue,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Centre de Notifications",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_notifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                icon: const Icon(Icons.done_all, color: AppTheme.brickOrange),
                tooltip: "Tout marquer comme lu",
                onPressed: () {
                  setState(() {
                    for (var n in _notifications) {
                      n['isUnread'] = false;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tout est marqué comme lu")),
                  );
                },
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: groupedNotifications.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = groupedNotifications[index];

                // Si c'est un String, c'est un titre de section (Date)
                if (item is String) {
                  return _buildDateHeader(item);
                }

                // Sinon c'est une notification
                return _buildDismissibleNotification(
                  item as Map<String, dynamic>,
                );
              },
            ),
    );
  }

  // Logique de regroupement
  List<dynamic> _groupNotifications() {
    List<dynamic> grouped = [];
    String? lastDate;

    for (var notif in _notifications) {
      if (notif['dateSection'] != lastDate) {
        grouped.add(notif['dateSection']); // Ajoute le header
        lastDate = notif['dateSection'];
      }
      grouped.add(notif); // Ajoute l'item
    }
    return grouped;
  }

  Widget _buildDateHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5, top: 10),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDismissibleNotification(Map<String, dynamic> notif) {
    return Dismissible(
      key: Key(notif['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 25),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((item) => item['id'] == notif['id']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Notification supprimée"),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border(
            left: BorderSide(color: _getBorderColor(notif['type']), width: 5),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          leading: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getBorderColor(notif['type']).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(notif['type']),
                  color: _getBorderColor(notif['type']),
                  size: 22,
                ),
              ),
              if (notif['isUnread'])
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppTheme.brickOrange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notif['title'],
                style: TextStyle(
                  fontWeight: notif['isUnread']
                      ? FontWeight.bold
                      : FontWeight.w600,
                  fontSize: 15,
                  color: AppTheme.darkBlue,
                ),
              ),
              Text(
                notif['time'],
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              notif['body'],
              style: TextStyle(
                color: notif['isUnread']
                    ? Colors.black87
                    : Colors.grey.shade600,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppTheme.darkBlue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.bellSlash,
              size: 60,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Rien à signaler !",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Vous êtes à jour sur toutes vos notifications.",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Color _getBorderColor(String type) {
    switch (type) {
      case "warning":
        return Colors.orange;
      case "success":
        return Colors.green;
      case "document":
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case "warning":
        return Icons.warning_amber_rounded;
      case "success":
        return Icons.check_circle_outline;
      case "document":
        return FontAwesomeIcons.fileInvoice;
      default:
        return Icons.info_outline;
    }
  }
}
