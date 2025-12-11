// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loyerapp/features/payment/payment_success_screen.dart';

import '../../config/theme.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // 0 = MTN, 1 = Moov, 2 = Carte
  int _selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0", "fr_FR");

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.darkBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Paiement Sécurisé",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LE TICKET RÉCAPITULATIF
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Montant Total à Payer",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "50.000 FCFA",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Color(0xFFEEEEEE),
                    ), // Trait gris très clair
                    const SizedBox(height: 20),
                    _buildTicketRow("Loyer", "Décembre 2025"),
                    const SizedBox(height: 10),
                    _buildTicketRow("Bien", "Appt A12 - Rés. Palmiers"),
                    const SizedBox(height: 10),
                    _buildTicketRow(
                      "Frais de transaction",
                      "0 FCFA",
                      isGreen: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 2. CHOIX DU MOYEN DE PAIEMENT
            const Text(
              "Moyen de paiement",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBlue,
              ),
            ),
            const SizedBox(height: 20),

            // MTN MOBILE MONEY
            _buildPaymentMethod(
              index: 0,
              name: "MTN Mobile Money",
              color: const Color(0xFFFFCC00), // Jaune MTN
              textColor: Colors.black,
              icon: Icons.phone_android_rounded,
            ),

            const SizedBox(height: 15),

            // MOOV MONEY
            _buildPaymentMethod(
              index: 1,
              name: "Moov Money",
              color: const Color(0xFF0066CC), // Bleu Moov
              textColor: Colors.white,
              icon: Icons.wifi_tethering,
            ),

            const SizedBox(height: 15),

            // CARTE BANCAIRE
            _buildPaymentMethod(
              index: 2,
              name: "Carte Bancaire",
              color: AppTheme.darkBlue,
              textColor: Colors.white,
              icon: FontAwesomeIcons.creditCard,
            ),

            const Spacer(), // Pousse le bouton vers le bas
            // 3. BOUTON DE CONFIRMATION
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Dans payment_screen.dart
                  onPressed: () {
                    // Simule un délai de traitement puis va vers Success
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.brickOrange,
                        ),
                      ),
                    );

                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context); // Ferme le loader
                      Navigator.pushReplacement(
                        // Remplace l'écran actuel
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentSuccessScreen(),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppTheme.successGreen, // Vert pour valider l'argent
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: AppTheme.successGreen.withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 18),
                      SizedBox(width: 10),
                      Text(
                        "CONFIRMER LE PAIEMENT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildTicketRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isGreen ? AppTheme.successGreen : AppTheme.darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod({
    required int index,
    required String name,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) {
    bool isSelected = _selectedMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo simulé
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),

            // Nom
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppTheme.darkBlue,
                ),
              ),
            ),

            // Radio Button Custom
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 16, color: textColor)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Simulation de chargement
  void _showProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppTheme.brickOrange),
              const SizedBox(height: 20),
              const Text(
                "Connexion à l'opérateur...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Veuillez valider sur votre téléphone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
