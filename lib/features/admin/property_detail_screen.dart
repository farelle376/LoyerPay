import 'package:flutter/material.dart';

import '../../config/theme.dart';
import 'edit_property_screen.dart';
import 'tenant_detail_screen.dart'; // Pour aller voir le locataire

class PropertyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> property;

  const PropertyDetailScreen({
    super.key,
    this.property = const {
      "name": "Résidence Les Palmiers",
      "address": "Cotonou, Haie Vive",
      "image":
          "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=500",
      "units": 12,
      "occupied": 10,
    },
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: CustomScrollView(
        slivers: [
          // 1. HEADER AVEC IMAGE (SliverAppBar)
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: AppTheme.darkBlue,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditPropertyScreen(propertyData: property),
                      ),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                property['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(property['image'], fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. STATISTIQUES RAPIDES
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        property['address'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatCard(
                        "Total Lots",
                        "${property['units']}",
                        Icons.grid_view,
                        Colors.blue,
                      ),
                      const SizedBox(width: 15),
                      _buildStatCard(
                        "Occupés",
                        "${property['occupied']}",
                        Icons.people,
                        Colors.green,
                      ),
                      const SizedBox(width: 15),
                      _buildStatCard(
                        "Vacants",
                        "${property['units'] - property['occupied']}",
                        Icons.key,
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Unités & Locataires",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. LISTE DES APPARTEMENTS (UNITÉS)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildUnitCard(context, index);
              }, childCount: property['units']),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String count,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitCard(BuildContext context, int index) {
    bool isOccupied = index < 10; // Simulation : les 10 premiers sont occupés

    return GestureDetector(
      onTap: () {
        if (isOccupied) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TenantDetailScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cet appartement est vide. Ajouter un locataire ?"),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border(
            left: BorderSide(
              color: isOccupied ? Colors.green : Colors.orange,
              width: 5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "A${index + 1}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOccupied ? "M. Koffi (Locataire)" : "VACANT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isOccupied ? Colors.black87 : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "3 Pièces • 2ème Étage",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
