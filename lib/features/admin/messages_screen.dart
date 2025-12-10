import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../tenant/tenant_chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Données simulées (Discussions)
  final List<Map<String, dynamic>> _chats = [
    {
      "name": "Mamadou Diop",
      "msg": "Bonjour, j'ai envoyé la preuve de paiement.",
      "time": "10:30",
      "unread": 2,
      "img": "https://i.pravatar.cc/150?img=11",
    },
    {
      "name": "Sarah Kaba",
      "msg": "Merci pour l'intervention rapide !",
      "time": "Hier",
      "unread": 0,
      "img": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Jean-Luc K.",
      "msg": "Est-ce possible de décaler le loyer ?",
      "time": "Hier",
      "unread": 1,
      "img": "https://i.pravatar.cc/150?img=3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Messagerie",
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
            Tab(text: "Discussions"),
            Tab(text: "Nouvelle Annonce"), // Le mode Broadcast
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ONGLET 1 : LISTE DES CHATS
          _buildChatList(),

          // ONGLET 2 : ENVOYER UNE ANNONCE (BROADCAST)
          _buildBroadcastForm(),
        ],
      ),
    );
  }

  // --- WIDGET ONGLET 1 : CHATS ---
  Widget _buildChatList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _chats.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final chat = _chats[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TenantChatScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(
                    alpha: 0.05,
                  ), // .withOpacity si version Flutter < 3.22
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(chat['img']),
                ),
                const SizedBox(width: 15),

                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat['name'],
                            style: TextStyle(
                              fontWeight: chat['unread'] > 0
                                  ? FontWeight.bold
                                  : FontWeight.w600, // Gras si non lu
                              fontSize: 16,
                              color: AppTheme.darkBlue,
                            ),
                          ),
                          Text(
                            chat['time'],
                            style: TextStyle(
                              color: chat['unread'] > 0
                                  ? AppTheme.brickOrange
                                  : Colors.grey.shade400,
                              fontWeight: chat['unread'] > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['msg'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: chat['unread'] > 0
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                                fontWeight: chat['unread'] > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (chat['unread'] > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppTheme.brickOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                chat['unread'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // --- WIDGET ONGLET 2 : BROADCAST ---

  Widget _buildBroadcastForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppTheme.brickOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppTheme.brickOrange.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.campaign, color: AppTheme.brickOrange),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Ce message sera envoyé à tous les locataires sélectionnés.",
                    style: TextStyle(
                      color: AppTheme.brickOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          const Text(
            "Cible",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: "Tous les locataires",
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F7FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: "Tous les locataires",
                child: Text("Tous les locataires"),
              ),
              DropdownMenuItem(
                value: "Résidence Palmiers",
                child: Text("Résidence Palmiers"),
              ),
              DropdownMenuItem(
                value: "Retardataires",
                child: Text("Uniquement les retardataires"),
              ),
            ],
            onChanged: (v) {},
          ),

          const SizedBox(height: 20),

          const Text(
            "Sujet",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Ex: Coupure d'eau, Rappel loyer...",
              filled: true,
              fillColor: const Color(0xFFF4F7FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Message",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: 6,
            decoration: InputDecoration(
              hintText: "Votre message ici...",
              filled: true,
              fillColor: const Color(0xFFF4F7FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Diffusion envoyée !")),
                );
              },
              icon: const Icon(Icons.send_rounded),
              label: const Text("ENVOYER LA DIFFUSION"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
