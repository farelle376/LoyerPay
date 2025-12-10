import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loyerapp/features/admin/add_property_screen.dart';
import 'package:loyerapp/features/admin/financial_report_screen.dart';

import '../../config/theme.dart';
import 'property_detail_screen.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({super.key});

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
          "Mon Parc Immobilier",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppTheme.brickOrange,
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPropertyScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: AppTheme.darkBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinancialReportScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          // STATS RAPIDES
          Row(
            children: [
              _buildSummaryCard("Total Biens", "16", Colors.blue),
              const SizedBox(width: 15),
              _buildSummaryCard("Vacants", "1", Colors.red),
              const SizedBox(width: 15),
              _buildSummaryCard("En Travaux", "2", Colors.orange),
            ],
          ),

          const SizedBox(height: 25),
          const Text(
            "Résidences & Maisons",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 15),

          // LISTE DES BIENS
          _buildPropertyCard(
            context,
            "Résidence Les Palmiers",
            "Cotonou, Haie Vive",
            "12 Appartements",
            "100% Loué",
            Colors.green,
            "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=500",
          ),
          _buildPropertyCard(
            context,
            "Villa Cocody",
            "Cotonou, Fidjrossè",
            "Maison Individuelle",
            "Vacant",
            Colors.red,
            "https://images.unsplash.com/photo-1600596542815-60c37c6525fa?w=500",
          ),
          _buildPropertyCard(
            context,
            "Immeuble Le Phare",
            "Porto-Novo",
            "6 Appartements • 2 Magasins",
            "En Travaux",
            Colors.orange,
            "https://images.unsplash.com/photo-1580587771525-78b9dba3b91d?w=500",
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // N'oublie pas d'ajouter cet import en haut du fichier :
  // import 'property_detail_screen.dart';

  Widget _buildPropertyCard(
    BuildContext context, // <--- AJOUTÉ : On a besoin du context pour naviguer
    String title,
    String location,
    String details,
    String status,
    Color statusColor,
    String imgUrl,
  ) {
    return GestureDetector(
      // --- LA NAVIGATION EST ICI ---
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PropertyDetailScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(imgUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge Status
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: statusColor, size: 10),
                      const SizedBox(width: 5),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Infos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.building,
                        color: AppTheme.brickOrange,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        details,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
