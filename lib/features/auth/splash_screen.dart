import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loyerapp/features/auth/onboarding_screen.dart';

import '../../config/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // CONTRÔLEURS
  late AnimationController _mainController; // Séquence principale (2.5s)
  late AnimationController _particleController; // Explosion (1s)
  late AnimationController _shimmerController; // Lumière texte (Infini)
  late AnimationController _bgController; // Fond rotatif (Infini)

  // ANIMATIONS
  late Animation<double> _houseRotation; // 3D Y-Axis
  late Animation<double> _houseScale;
  late Animation<double> _rippleScale; // Onde de choc
  late Animation<double> _rippleOpacity;
  late Animation<double> _checkScale;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    // 1. Initialisation des Contrôleurs
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    // 2. Chorégraphie (Séquence temporelle sur 0.0 -> 1.0)

    // A. Maison : Arrive en tournant (3D)
    _houseRotation = Tween<double>(begin: math.pi, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _houseScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // B. Onde de choc (Ripple) : S'étend juste avant que la coche n'arrive
    _rippleScale = Tween<double>(begin: 0.5, end: 2.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutExpo),
      ),
    );
    _rippleOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.7,
          0.9,
          curve: Curves.easeIn,
        ), // Disparaît à la fin
      ),
    );

    // C. Coche Orange : Impact !
    _checkScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 0.85, curve: Curves.elasticOut),
      ),
    );

    // D. Texte : Glisse vers le haut
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.7, 0.9, curve: Curves.easeIn),
      ),
    );

    // 3. Exécution
    _mainController.forward();

    // Déclenchement des particules à l'impact (60% de 2500ms = 1500ms)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _particleController.forward();
    });

    // Navigation Finale
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        // Navigation Finale
        Future.delayed(const Duration(milliseconds: 3500), () {
          if (mounted) {
            // On utilise pushReplacement pour qu'on ne puisse pas revenir
            // au splash screen en faisant "Retour"
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const OnboardingScreen(),
              ), // Vers Onboarding
            );
          }
        }); // Navigator.of(context).pushReplacement(...)
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. FOND ROTATIF (De la V3)
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: Alignment.center,
                    startAngle: 0.0,
                    endAngle: math.pi * 2,
                    colors: const [
                      Colors.white,
                      Color(0xFFF0F4F8),
                      Colors.white,
                      Color(0xFFE3F2FD),
                      Colors.white,
                    ],
                    transform: GradientRotation(
                      _bgController.value * 2 * math.pi,
                    ),
                  ),
                ),
              );
            },
          ),

          // 2. CONTENU CENTRAL
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- ZONE LOGO COMPLÈTE ---
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // A. Onde de choc (Ripple) (De la V2)
                      AnimatedBuilder(
                        animation: _rippleScale,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _rippleOpacity.value,
                            child: Transform.scale(
                              scale: _rippleScale.value,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.brickOrange.withOpacity(0.2),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // B. Maison 3D (De la V2)
                      AnimatedBuilder(
                        animation: _houseRotation,
                        builder: (context, child) {
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // Perspective
                              ..rotateY(_houseRotation.value) // Rotation
                              ..scale(_houseScale.value),
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.darkBlue.withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.house,
                                size: 80,
                                color: AppTheme.darkBlue,
                              ),
                            ),
                          );
                        },
                      ),

                      // C. Particules (De la V3)
                      AnimatedBuilder(
                        animation: _particleController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: ParticlePainter(
                              progress: _particleController.value,
                              color: AppTheme.brickOrange,
                            ),
                            size: const Size(120, 120),
                          );
                        },
                      ),

                      // D. Coche Orange (De la V3)
                      Positioned(
                        bottom: 35,
                        right: 35,
                        child: ScaleTransition(
                          scale: _checkScale,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(
                              color: AppTheme.brickOrange,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.check,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- ZONE TEXTE SHIMMER (De la V2) ---
                FadeTransition(
                  opacity: _textOpacity,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Column(
                      children: [
                        // Titre avec effet de lumière
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: const [
                                    AppTheme.darkBlue,
                                    AppTheme.brickOrange,
                                    AppTheme.darkBlue,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                  begin: Alignment(
                                    -1.0 + (2.5 * _shimmerController.value),
                                    0.0,
                                  ),
                                  end: Alignment(
                                    1.0 + (2.5 * _shimmerController.value),
                                    0.0,
                                  ),
                                  tileMode: TileMode.clamp,
                                ).createShader(bounds);
                              },
                              child: const Text(
                                'LoyerPay',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -1.0,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        // Slogan Luxe (De la V3)
                        Text(
                          "L'IMMOBILIER NOUVELLE GÉNÉRATION",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                            color: AppTheme.darkBlue.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Peintre de particules (V3)
class ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  ParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0 || progress == 1.0) return;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final center = Offset(
      size.width / 2 + 40,
      size.height / 2 + 40,
    ); // Ajusté vers la coche
    final radius = 60.0 * progress;
    final particleSize = 5.0 * (1 - progress);

    for (int i = 0; i < 12; i++) {
      final angle = (i * 2 * math.pi) / 12;
      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(dx, dy), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
