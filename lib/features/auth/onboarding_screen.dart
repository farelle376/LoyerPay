import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/theme.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  double _pageOffset = 0.0;

  // Contrôleurs pour les animations d'arrière-plan et d'icônes
  late AnimationController _backgroundController;
  late AnimationController _iconFloatController;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Gérez vos loyers simplement",
      "body":
          "Plus de stress. Payez votre loyer en un clic via Mobile Money et recevez vos quittances instantanément.",
      "icon": FontAwesomeIcons.handHoldingDollar,
      "color": AppTheme.brickOrange,
    },
    {
      "title": "Signalez vos problèmes",
      "body":
          "Une fuite ? Une panne ? Prenez une photo, envoyez, et suivez l'intervention en temps réel.",
      "icon": FontAwesomeIcons.screwdriverWrench,
      "color": Colors.blue,
    },
    {
      "title": "Communication Fluide",
      "body":
          "Discutez directement avec votre gestionnaire et restez informé des annonces de la résidence.",
      "icon": FontAwesomeIcons.comments,
      "color": Colors.purple,
    },
  ];

  @override
  void initState() {
    super.initState();
    // 1. Setup Background Animation (Lent et continu)
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    // 2. Setup Icon Floating Animation (Plus rapide, effet de respiration)
    _iconFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // 3. Listen to page scroll for Parallax effect
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _iconFloatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- COUCHE 1 : FOND ANIMÉ (BLOBS) ---
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Blob Orange en haut à gauche
                    Positioned(
                      top: -100 + (_backgroundController.value * 50),
                      left: -100 + (_backgroundController.value * 30),
                      child: _buildBlurBlob(
                        AppTheme.brickOrange.withOpacity(0.15),
                        300,
                      ),
                    ),
                    // Blob Bleu en bas à droite
                    Positioned(
                      bottom: -150 + (_backgroundController.value * -40),
                      right: -150 + (_backgroundController.value * -20),
                      child: _buildBlurBlob(
                        AppTheme.darkBlue.withOpacity(0.1),
                        400,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // --- COUCHE 2 : PAGEVIEW AVEC PARALLAXE ---
          SafeArea(
            child: Column(
              children: [
                // BOUTON PASSER
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: TextButton(
                      onPressed: _goToLogin,
                      child: const Text(
                        "Passer",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      // Calcul du décalage pour l'effet parallaxe
                      double percent = index - _pageOffset;
                      // L'image bouge moins vite que le texte (0.5 vs 1.0 de movement speed standard)
                      double parallaxOffset = percent * 50;

                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ANIMATED FLOATING ICON CORE
                            Transform.translate(
                              offset: Offset(
                                parallaxOffset,
                                0,
                              ), // Parallaxe horizontale
                              child: _buildFloatingHeroIcon(index),
                            ),
                            const SizedBox(height: 50),

                            // TEXTS WITH SLIGHT PARALLAX DELAY
                            Transform.translate(
                              offset: Offset(
                                parallaxOffset * 1.5,
                                0,
                              ), // Le texte bouge un peu plus vite
                              child: Column(
                                children: [
                                  Text(
                                    _pages[index]['title']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.darkBlue,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _pages[index]['body']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // --- COUCHE 3 : BOTTOM CONTROLS ---
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicateurs animés
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.elasticOut,
                            margin: const EdgeInsets.only(right: 8),
                            height: 10,
                            // L'indicateur actif est plus long et change de couleur
                            width: _currentPage == index ? 35 : 10,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? _pages[_currentPage]['color']
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      // Bouton Suivant animé
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == _pages.length - 1 ? 140 : 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _pages[_currentPage]['color'],
                          borderRadius: BorderRadius.circular(
                            _currentPage == _pages.length - 1 ? 20 : 30,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _pages[_currentPage]['color'].withOpacity(
                                0.4,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              if (_currentPage < _pages.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 600),
                                  curve:
                                      Curves.easeOutCubic, // Courbe plus fluide
                                );
                              } else {
                                _goToLogin();
                              }
                            },
                            child: Center(
                              child: _currentPage == _pages.length - 1
                                  ? const Text(
                                      "COMMENCER",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: CERCLE FLOU D'ARRIÈRE-PLAN ---
  Widget _buildBlurBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  // --- WIDGET: ICÔNE PRINCIPALE QUI FLOTTE ---
  Widget _buildFloatingHeroIcon(int index) {
    return AnimatedBuilder(
      animation: _iconFloatController,
      builder: (context, child) {
        // Utilisation de Sinus pour un mouvement de flottement naturel haut/bas
        final double bounceValue = math.sin(
          _iconFloatController.value * math.pi * 2,
        );
        // Légère rotation pour plus de dynamisme
        final double rotateValue =
            math.sin(_iconFloatController.value * math.pi) * 0.05;

        return Transform.translate(
          offset: Offset(
            0,
            bounceValue * 15,
          ), // Flottement vertical de 15 pixels
          child: Transform.rotate(
            angle: rotateValue,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                color: _pages[index]['color'].withOpacity(0.1),
                shape: BoxShape.circle,
                // Double bordure pour effet de profondeur
                border: Border.all(color: Colors.white, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: _pages[index]['color'].withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _pages[index]['icon'],
                  size: 90,
                  color: _pages[index]['color'],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
