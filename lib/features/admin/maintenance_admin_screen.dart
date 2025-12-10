import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/theme.dart';

class MaintenanceAdminScreen extends StatefulWidget {
  const MaintenanceAdminScreen({super.key});

  @override
  State<MaintenanceAdminScreen> createState() => _MaintenanceAdminScreenState();
}

class _MaintenanceAdminScreenState extends State<MaintenanceAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Données simulées (Tickets)
  final List<Map<String, dynamic>> _tickets = [
    {
      "id": "#TICK-204",
      "tenant": "Mamadou Diop",
      "appt": "Appt A12",
      "issue": "Fuite d'eau importante sous l'évier",
      "category": "Plomberie",
      "priority": "Urgent",
      "date": "Aujourd'hui, 09:30",
      "status": "Nouveau",
      "img": "https://i.pravatar.cc/150?img=11",
    },
    {
      "id": "#TICK-203",
      "tenant": "Sarah Kaba",
      "appt": "Villa 02",
      "issue": "La climatisation du salon ne refroidit plus",
      "category": "Clim",
      "priority": "Moyen",
      "date": "Hier, 14:15",
      "status": "En cours",
      "img": "https://i.pravatar.cc/150?img=5",
    },
    {
      "id": "#TICK-199",
      "tenant": "Jean-Luc K.",
      "appt": "Studio B05",
      "issue": "Ampoule du couloir grillée",
      "category": "Électricité",
      "priority": "Faible",
      "date": "03 Déc",
      "status": "Terminé",
      "img": "https://i.pravatar.cc/150?img=3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.darkBlue,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Gestion des Problèmes",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.brickOrange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.brickOrange,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Nouveaux"),
            Tab(text: "En cours"),
            Tab(text: "Terminés"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTicketList("Nouveau"),
          _buildTicketList("En cours"),
          _buildTicketList("Terminé"),
        ],
      ),
    );
  }

  Widget _buildTicketList(String filterStatus) {
    // Filtrer la liste (Simulation)
    // Dans la vraie vie, on filtrerait _tickets.where(...)
    // Ici on affiche tout pour l'exemple visuel, sauf si c'est "Terminé"
    final displayTickets = _tickets;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: displayTickets.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final ticket = displayTickets[index];
        return _buildTicketCard(ticket);
      },
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    Color priorityColor;
    switch (ticket['priority']) {
      case "Urgent":
        priorityColor = Colors.red;
        break;
      case "Moyen":
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // HEADER CARTE (Info Locataire)
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(ticket['img']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['tenant'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBlue,
                        ),
                      ),
                      Text(
                        ticket['appt'],
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticket['priority'],
                    style: TextStyle(
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // CORPS CARTE (Le Problème)
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône Catégorie
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(ticket['category']),
                    color: AppTheme.darkBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ticket['category'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ticket['date'],
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        ticket['issue'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FOOTER CARTE (Actions)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFD),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket['id'],
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _buildActionButton(Icons.phone, Colors.green, "Appeler"),
                    const SizedBox(width: 10),
                    _buildActionButton(
                      Icons.check,
                      AppTheme.darkBlue,
                      "Résoudre",
                      isPrimary: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    Color color,
    String label, {
    bool isPrimary = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: isPrimary ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: isPrimary ? color : Colors.transparent,
        border: Border.all(
          color: isPrimary ? Colors.transparent : color.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isPrimary ? Colors.white : color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Plomberie":
        return FontAwesomeIcons.faucetDrip;
      case "Électricité":
        return FontAwesomeIcons.bolt;
      case "Clim":
        return FontAwesomeIcons.temperatureArrowUp;
      default:
        return FontAwesomeIcons.screwdriverWrench;
    }
  }
}
