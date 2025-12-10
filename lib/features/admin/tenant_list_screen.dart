// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../config/theme.dart';
import 'add_tenant_screen.dart';
import 'tenant_detail_screen.dart';

class TenantListScreen extends StatefulWidget {
  const TenantListScreen({super.key});

  @override
  State<TenantListScreen> createState() => _TenantListScreenState();
}

class _TenantListScreenState extends State<TenantListScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["Tous", "À jour", "Retard", "Fin contrat"];

  // Données simulées
  final List<Map<String, dynamic>> _tenants = [
    {
      "name": "Mamadou Diop",
      "appt": "Appt A12 - Rés. Palmiers",
      "status": "Retard",
      "amount": "-50.000 F",
      "phone": "+229 00 00 00 00",
      "img": "https://i.pravatar.cc/150?img=11",
    },
    {
      "name": "Sarah Kaba",
      "appt": "Villa 02 - Cotonou",
      "status": "À jour",
      "amount": "0 F",
      "phone": "+229 00 00 00 00",
      "img": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Jean-Luc K.",
      "appt": "Studio B05",
      "status": "Fin contrat",
      "amount": "Expire dans 2 mois",
      "phone": "+229 00 00 00 00",
      "img": "https://i.pravatar.cc/150?img=3",
    },
    {
      "name": "Aïcha Traoré",
      "appt": "Appt C04 - Rés. Cocotiers",
      "status": "À jour",
      "amount": "0 F",
      "phone": "+229 00 00 00 00",
      "img": "https://i.pravatar.cc/150?img=9",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),

      // HEADER AVEC RECHERCHE
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FC),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Rechercher un locataire...",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list_rounded,
              color: AppTheme.darkBlue,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          // 1. FILTRES (Chips horizontaux)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(_filters[index]),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      selectedColor: AppTheme.darkBlue,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.shade200,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // 2. LISTE DES LOCATAIRES
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _tenants.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final tenant = _tenants[index];
                return _buildTenantCard(tenant);
              },
            ),
          ),
        ],
      ),

      // 3. FAB (Bouton Ajouter)
      // Dans tenant_list_screen.dart
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigation vers le formulaire d'ajout
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTenantScreen()),
          );
        },
        backgroundColor: AppTheme.brickOrange,
        icon: const Icon(Icons.add),
        label: const Text("Ajouter"),
      ),
    );
  }

  Widget _buildTenantCard(Map<String, dynamic> tenant) {
    Color statusColor;
    IconData statusIcon;

    switch (tenant['status']) {
      case "Retard":
        statusColor = Colors.redAccent;
        statusIcon = Icons.warning_amber_rounded;
        break;
      case "Fin contrat":
        statusColor = Colors.orange;
        statusIcon = Icons.history_edu;
        break;
      default:
        statusColor = AppTheme.successGreen;
        statusIcon = Icons.check_circle_outline;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TenantDetailScreen(
              name: tenant['name'],
              appt: tenant['appt'],
              imgUrl: tenant['img'],
            ),
          ),
        );
      },
      child: Container(
        // Ajout du Container manquant pour le style
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.05,
              ), // Attention: utilise .withValues(alpha: 0.05) si tu veux être à jour
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .center, // <--- IMPORTANT : Centre tout verticalement
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(tenant['img']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 15),

            // Infos (Au milieu)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Centré aussi
                children: [
                  Text(
                    tenant['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tenant['appt'],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tenant['status'] == "Retard"
                          ? "${tenant['status']} (${tenant['amount']})"
                          : tenant['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10), // Espace avant les boutons
            // Actions Rapides (À droite)
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // <--- Evite l'étirement
              mainAxisSize:
                  MainAxisSize.min, // <--- Prend juste la place nécessaire
              children: [
                _buildIconButton(Icons.phone, Colors.green),
                const SizedBox(height: 12), // <--- Un peu plus d'espace
                _buildIconButton(Icons.message, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
