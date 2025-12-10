import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/theme.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  // Catégorie sélectionnée (0 = Plomberie par défaut)
  int _selectedCategory = 0;
  // Urgence (0 = Basse, 1 = Moyenne, 2 = Haute)
  int _priorityLevel = 1;

  final List<Map<String, dynamic>> _categories = [
    {'icon': FontAwesomeIcons.faucetDrip, 'label': 'Plomberie'},
    {'icon': FontAwesomeIcons.bolt, 'label': 'Électricité'},
    {'icon': FontAwesomeIcons.key, 'label': 'Serrurerie'},
    {'icon': FontAwesomeIcons.temperatureArrowUp, 'label': 'Climatisation'},
    {'icon': FontAwesomeIcons.bug, 'label': 'Nuisibles'},
    {'icon': FontAwesomeIcons.ellipsis, 'label': 'Autre'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Nouvelle demande",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. QUESTION PRINCIPALE
            const Text(
              "Quel est le problème ?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBlue,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Sélectionnez la catégorie concernée",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 20),

            // 2. GRILLE DE CATÉGORIES (Sélecteur Visuel)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.0,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategory == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.darkBlue
                          : const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.darkBlue.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          _categories[index]['icon'],
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _categories[index]['label'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // 3. PRIORITÉ (Sélecteur à 3 niveaux)
            const Text(
              "Niveau d'urgence",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  _buildPriorityBtn("Faible", Colors.green, 0),
                  _buildPriorityBtn("Moyen", Colors.orange, 1),
                  _buildPriorityBtn("Urgent", Colors.red, 2),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. DESCRIPTION & PHOTOS
            const Text(
              "Détails",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Décrivez le problème en quelques mots...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                fillColor: const Color(0xFFF5F6FA),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Zone d'upload photo
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ), // Style pointillé simulé
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    color: AppTheme.brickOrange,
                    size: 30,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Ajouter une photo (Optionnel)",
                    style: TextStyle(
                      color: AppTheme.brickOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 5. BOUTON ENVOYER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simulation d'envoi
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Signalement envoyé !"),
                      backgroundColor: AppTheme.successGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("ENVOYER LE SIGNALEMENT"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour les boutons de priorité
  Widget _buildPriorityBtn(String label, Color color, int index) {
    final isSelected = _priorityLevel == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priorityLevel = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
