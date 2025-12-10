import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/theme.dart';

class LoyerPayLogo extends StatelessWidget {
  final double size;
  final bool isLight; // Si true, le texte est blanc (pour fond sombre)

  const LoyerPayLogo({super.key, this.size = 100, this.isLight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // L'ICÔNE GRAPHIQUE
        SizedBox(
          height: size,
          width: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // La maison
              FaIcon(
                FontAwesomeIcons.house,
                size: size * 0.8,
                color: isLight ? Colors.white : AppTheme.darkBlue,
              ),
              // La coche orange (le "Pay")
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(size * 0.15),
                  decoration: const BoxDecoration(
                    color: AppTheme.brickOrange,
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.check,
                    size: size * 0.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size * 0.2), // Espacement
        // LE TEXTE (OPTIONNEL, SI ON VEUT LE LOGO COMPLET)
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Poppins', // Assure-toi que la police est chargée
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              color: isLight ? Colors.white : AppTheme.darkBlue,
            ),
            children: const [
              TextSpan(text: 'Loyer'),
              TextSpan(
                text: 'Pay',
                style: TextStyle(color: AppTheme.brickOrange),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
