import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/theme.dart';
import '../auth/login_screen.dart';
import '../tenant/contract_screen.dart'; // Contient le contrat
import 'edit_profile_screen.dart';
import 'settings_sub_screens.dart'; // Contient Info, Sécurité, Aide, Confidentialité

class ProfileScreen extends StatefulWidget {
  final bool isTenant; // Pour adapter l'affichage si besoin

  const ProfileScreen({super.key, this.isTenant = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

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
          "Mon Profil",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. CARTE D'IDENTITÉ
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          widget.isTenant
                              ? "https://i.pravatar.cc/150?img=11" // Image Locataire
                              : "https://i.pravatar.cc/150?img=12", // Image Admin
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.brickOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isTenant ? "M. Koffi" : "Admin Directeur",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBlue,
                          ),
                        ),
                        Text(
                          widget.isTenant
                              ? "koffi@email.com"
                              : "admin@fari-immo.com",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.darkBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.isTenant
                                ? "Locataire Vérifié"
                                : "Administrateur",
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.darkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            // On passe les infos actuelles (simulées ici)
                            currentName: widget.isTenant
                                ? "M. Koffi"
                                : "Admin Directeur",
                            currentEmail: widget.isTenant
                                ? "koffi@email.com"
                                : "admin@fari.com",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 2. PARAMÈTRES DU COMPTE
            _buildSectionTitle("Compte"),

            _buildSettingsTile(
              icon: FontAwesomeIcons.userShield,
              title: "Infos Personnelles",
              subtitle: "Nom, Email, Téléphone",
              onTap: () {
                // Navigation vers Infos Personnelles
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalInfoScreen(),
                  ),
                );
              },
            ),

            _buildSettingsTile(
              icon: FontAwesomeIcons.fileContract,
              title: widget.isTenant
                  ? "Mon Contrat de Bail"
                  : "Documents Légaux",
              subtitle: "Voir les documents signés",
              onTap: () {
                // Navigation vers le Contrat (réutilisation de l'écran existant)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContractScreen(),
                  ),
                );
              },
            ),

            _buildSettingsTile(
              icon: FontAwesomeIcons.lock,
              title: "Sécurité & Mot de passe",
              subtitle: "Modifier mon mot de passe",
              onTap: () {
                // Navigation vers Sécurité
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecurityScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // 3. PRÉFÉRENCES (Switchs)
            _buildSectionTitle("Préférences"),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: AppTheme.brickOrange,
                    title: const Text(
                      "Notifications Push",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
                    value: _notificationsEnabled,
                    onChanged: (val) =>
                        setState(() => _notificationsEnabled = val),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  SwitchListTile(
                    activeColor: AppTheme.brickOrange,
                    title: const Text(
                      "Face ID / Biométrie",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        color: Colors.purple,
                        size: 18,
                      ),
                    ),
                    value: _biometricsEnabled,
                    onChanged: (val) =>
                        setState(() => _biometricsEnabled = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 4. SUPPORT
            _buildSectionTitle("Support"),
            _buildSettingsTile(
              icon: FontAwesomeIcons.circleQuestion,
              title: "Centre d'aide",
              subtitle: "FAQ et contact support",
              onTap: () {
                // Navigation vers Aide
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
            ),
            _buildSettingsTile(
              icon: FontAwesomeIcons.shieldHalved,
              title: "Confidentialité",
              subtitle: "Politique de données",
              onTap: () {
                // Navigation vers Confidentialité
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // 5. DÉCONNEXION
            TextButton(
              onPressed: () {
                // Retour à la page de Login et efface l'historique de navigation
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red.shade400, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Se déconnecter",
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Version 1.0.0 • Fari Immo",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.darkBlue.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.darkBlue, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
