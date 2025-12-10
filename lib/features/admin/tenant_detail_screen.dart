import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config/theme.dart';

class TenantDetailScreen extends StatefulWidget {
  // En vrai, on passerait l'objet Tenant ici.
  // Pour l'instant, on simule avec des données en dur.
  final String name;
  final String appt;
  final String imgUrl;

  const TenantDetailScreen({
    super.key,
    this.name = "Mamadou Diop",
    this.appt = "Appt A12 - Rés. Palmiers",
    this.imgUrl = "https://i.pravatar.cc/150?img=11",
  });

  @override
  State<TenantDetailScreen> createState() => _TenantDetailScreenState();
}

class _TenantDetailScreenState extends State<TenantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // ... (imports et début de classe identiques) ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        // On change pour NestedScrollView pour mieux gérer les tabs
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // ... (Garde ton code SliverAppBar existant avec l'image et l'avatar) ...
              expandedHeight: 320.0, // Un peu plus haut
              pinned: true,
              // ...
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.darkBlue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppTheme.brickOrange,
                    tabs: const [
                      Tab(text: "Historique"),
                      Tab(text: "Contrat"),
                      Tab(text: "Plaintes"),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // ONGLET 1 : HISTORIQUE (Déjà fait, je le mets en fonction)
            _buildHistoryTab(),

            // ONGLET 2 : CONTRAT (NOUVEAU)
            _buildContractTab(),

            // ONGLET 3 : PLAINTES (NOUVEAU)
            _buildComplaintsTab(),
          ],
        ),
      ),
    );
  }

  // --- CONTENU DES ONGLETS ---

  Widget _buildHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTransactionItem(
          "Loyer Décembre",
          "05 Déc 2024",
          "+ 50.000 F",
          true,
        ),
        _buildTransactionItem(
          "Loyer Novembre",
          "07 Nov 2024",
          "+ 50.000 F",
          true,
          isLate: true,
        ),
        _buildTransactionItem(
          "Réparation Robinet",
          "02 Nov 2024",
          "- 5.000 F",
          false,
        ),
      ],
    );
  }

  Widget _buildContractTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildInfoCard("Termes du Bail", [
          _buildInfoRow("Début", "01/01/2023"),
          _buildInfoRow("Fin", "31/12/2025"),
          _buildInfoRow("Loyer", "50.000 FCFA"),
          _buildInfoRow("Caution", "150.000 FCFA"),
        ]),
        const SizedBox(height: 20),
        _buildInfoCard("Documents", []),
        const SizedBox(height: 10),
        _buildFileTile("Contrat_Signé.pdf"),
        _buildFileTile("État_des_lieux.pdf"),
        _buildFileTile("Pièce_Identité.jpg"),
      ],
    );
  }

  Widget _buildComplaintsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildComplaintItem(
          "Fuite d'eau",
          "En cours",
          Colors.orange,
          "Aujourd'hui",
        ),
        _buildComplaintItem(
          "Ampoule couloir",
          "Résolu",
          Colors.green,
          "01 Nov 2024",
        ),
      ],
    );
  }

  // --- WIDGETS HELPERS SUPPLÉMENTAIRES ---

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFileTile(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.download_rounded, color: Colors.grey),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildComplaintItem(
    String title,
    String status,
    Color color,
    String date,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
  // ... (Garde tes anciennes fonctions _buildTransactionItem, _buildInfoRow, etc.)  // --- WIDGETS HELPERS ---

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String amount,
    bool isIncome, {
    bool isLate = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome
                  ? (isLate
                        ? Colors.orange.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1))
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome
                  ? (isLate ? Colors.orange : Colors.green)
                  : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isIncome ? AppTheme.darkBlue : Colors.red,
                ),
              ),
              if (isLate)
                const Text(
                  "Retard 2j",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Petit widget utilitaire pour les boutons ronds dans l'AppBar
class ContainerWithBlur extends StatelessWidget {
  final Widget child;
  const ContainerWithBlur({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white.withValues(alpha: 0.2),
          child: child,
        ),
      ),
    );
  }
}
