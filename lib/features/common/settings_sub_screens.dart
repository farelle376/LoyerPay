import 'package:flutter/material.dart';

import '../../config/theme.dart';
import 'edit_profile_screen.dart'; // Pour la modif d'infos

// 1. ÉCRAN INFORMATIONS PERSONNELLES (Lecture seule + Edit)
class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSimpleAppBar(context, "Infos Personnelles"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"),
            ),
            const SizedBox(height: 20),
            _buildInfoTile("Nom complet", "M. Koffi"),
            _buildInfoTile("Email", "koffi@email.com"),
            _buildInfoTile("Téléphone", "+229 97 00 00 00"),
            _buildInfoTile("Adresse", "Appt A12, Résidence Les Palmiers"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("MODIFIER MES INFOS"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. ÉCRAN SÉCURITÉ (Changer mot de passe)
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSimpleAppBar(context, "Sécurité"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Changer de mot de passe",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPassField("Mot de passe actuel"),
            const SizedBox(height: 15),
            _buildPassField("Nouveau mot de passe"),
            const SizedBox(height: 15),
            _buildPassField("Confirmer le nouveau mot de passe"),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Mot de passe mis à jour ! 🔒"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brickOrange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("METTRE À JOUR"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassField(String label) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color(0xFFF8F9FD),
      ),
    );
  }
}

// 3. ÉCRAN AIDE & SUPPORT (FAQ)
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: _buildSimpleAppBar(context, "Centre d'aide"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _FaqTile(
            "Comment payer mon loyer ?",
            "Allez dans l'onglet 'Payer', choisissez Mobile Money et suivez les instructions.",
          ),
          _FaqTile(
            "Comment signaler une panne ?",
            "Utilisez le bouton 'Signaler' sur l'accueil, prenez une photo et décrivez le problème.",
          ),
          _FaqTile(
            "Puis-je changer d'appartement ?",
            "Contactez l'administration via la messagerie pour discuter des disponibilités.",
          ),
          _FaqTile(
            "Où trouver mes quittances ?",
            "Dans l'onglet 'Mes Finances' ou 'Historique'.",
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String q, a;
  const _FaqTile(this.q, this.a);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: ExpansionTile(
        title: Text(
          q,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(a, style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }
}

// 4. ÉCRAN CONFIDENTIALITÉ (Texte)
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSimpleAppBar(context, "Confidentialité"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Politique de Confidentialité",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Dernière mise à jour : 09 Décembre 2025",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Text(
              "1. Collecte des données\nNous collectons vos informations (Nom, Email, Téléphone) uniquement pour la gestion de votre bail.\n\n"
              "2. Utilisation des données\nVos données sont utilisées pour générer vos contrats, quittances et pour la communication avec le syndic.\n\n"
              "3. Sécurité\nNous utilisons des protocoles sécurisés pour protéger vos informations de paiement.\n\n"
              "4. Vos droits\nVous pouvez demander la modification ou la suppression de vos données en contactant l'administration.",
              style: TextStyle(height: 1.6, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper pour l'AppBar commune
PreferredSizeWidget _buildSimpleAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: AppTheme.darkBlue,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
  );
}
