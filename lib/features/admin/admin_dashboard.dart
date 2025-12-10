import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loyerapp/features/common/profile_screen.dart';

import '../../config/theme.dart';
import '../common/notifications_screen.dart';
import 'maintenance_admin_screen.dart';
import 'messages_screen.dart'; // Assure-toi d'avoir créé ce fichier !
import 'properties_screen.dart'; // <--- Ajoute ça
import 'tenant_list_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // CLAIR PAR DÉFAUT
  bool _isDarkMode = false;

  // Données du graphique
  final List<FlSpot> _chartData = const [
    FlSpot(0, 1.2),
    FlSpot(1, 1.8),
    FlSpot(2, 1.5),
    FlSpot(3, 2.8),
    FlSpot(4, 2.2),
    FlSpot(5, 3.5),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutQuint),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // COULEURS DYNAMIQUES
    final bgColor = _isDarkMode
        ? const Color(0xFF0F1115)
        : const Color(0xFFF4F7FC);
    final cardColor = _isDarkMode ? const Color(0xFF161922) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : AppTheme.darkBlue;
    final subTextColor = _isDarkMode
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.grey;
    final glassBorderColor = _isDarkMode
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey.withValues(alpha: 0.05);
    final shadowColor = _isDarkMode
        ? Colors.black.withValues(alpha: 0.3)
        : const Color(0xFF0A2342).withValues(alpha: 0.08);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. BACKGROUND GLOWS
          Positioned(
            top: -100,
            left: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isDarkMode
                      ? AppTheme.darkBlue.withValues(alpha: 0.3)
                      : Colors.blue.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isDarkMode
                      ? AppTheme.brickOrange.withValues(alpha: 0.15)
                      : Colors.orange.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),

          // 2. CONTENU PRINCIPAL
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // HEADER (TITRE + ACTIONS)
                      // HEADER (TITRE + ACTIONS)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 1. TEXTES (Gauche)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "VUE D'ENSEMBLE",
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 7,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Tableau de Bord",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // 2. BOUTONS D'ACTION (Droite)
                          Row(
                            children: [
                              // A. BOUTON MESSAGE
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: glassBorderColor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.solidCommentDots,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : AppTheme.darkBlue,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MessagesScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // DANS ADMIN DASHBOARD (Header)
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: glassBorderColor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.notifications_none_rounded,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : AppTheme.darkBlue,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NotificationsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // B. BOUTON THÈME
                              Container(
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: glassBorderColor),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isDarkMode
                                        ? Icons.light_mode_rounded
                                        : Icons.dark_mode_rounded,
                                    color: _isDarkMode
                                        ? Colors.yellow
                                        : AppTheme.darkBlue,
                                    size: 20,
                                  ),
                                  onPressed: _toggleTheme,
                                ),
                              ),

                              // C. AVATAR (PROFIL) - CONNECTÉ ICI 👇
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen(isTenant: false),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: glassBorderColor,
                                        ),
                                      ),
                                      child: const CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                          'https://i.pravatar.cc/150?img=11',
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppTheme.successGreen,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: bgColor,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // GRAPHIQUE FINANCIER
                      Container(
                        height: 320,
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: glassBorderColor),
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Trésorerie Actuelle",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "4.250.000 F",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        shadows: _isDarkMode
                                            ? [
                                                Shadow(
                                                  color: AppTheme.brickOrange
                                                      .withValues(alpha: 0.5),
                                                  blurRadius: 10,
                                                ),
                                              ]
                                            : [],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successGreen.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward,
                                        color: AppTheme.successGreen,
                                        size: 14,
                                      ),
                                      Text(
                                        " +12%",
                                        style: TextStyle(
                                          color: AppTheme.successGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            Expanded(
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  minX: 0,
                                  maxX: 5,
                                  minY: 0,
                                  maxY: 4,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _chartData,
                                      isCurved: true,
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppTheme.brickOrange,
                                          Color(0xFFFF8C00),
                                        ],
                                      ),
                                      barWidth: 4,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) =>
                                                FlDotCirclePainter(
                                                  radius: 4,
                                                  color: cardColor,
                                                  strokeWidth: 2,
                                                  strokeColor:
                                                      AppTheme.brickOrange,
                                                ),
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppTheme.brickOrange.withValues(
                                              alpha: 0.3,
                                            ),
                                            AppTheme.brickOrange.withValues(
                                              alpha: 0.0,
                                            ),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // SECTION STATS RAPIDES
                      Row(
                        children: [
                          Expanded(
                            child: _buildGlassStatCard(
                              "Taux Occup.",
                              "92%",
                              "15/16 Biens",
                              Icons.home_work_rounded,
                              Colors.purpleAccent,
                              cardColor,
                              textColor,
                              glassBorderColor,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildGlassStatCard(
                              "Impayés",
                              "15%",
                              "350.000 F",
                              Icons.warning_amber_rounded,
                              Colors.redAccent,
                              cardColor,
                              textColor,
                              glassBorderColor,
                              isAlert: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // LISTE ROUGE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ALERTES CRITIQUES",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.more_horiz, color: subTextColor),
                        ],
                      ),
                      const SizedBox(height: 15),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildDangerCard(
                              "Mamadou D.",
                              "Appt A12",
                              "-15 Jours",
                              "50.000 F",
                              cardColor,
                              textColor,
                              glassBorderColor,
                            ),
                            const SizedBox(width: 15),
                            _buildDangerCard(
                              "Jean-Luc K.",
                              "Villa 05",
                              "-4 Jours",
                              "120.000 F",
                              cardColor,
                              textColor,
                              glassBorderColor,
                            ),
                            const SizedBox(width: 15),
                            _buildDangerCard(
                              "Sarah P.",
                              "Studio C1",
                              "Fin Contrat",
                              "N/A",
                              cardColor,
                              textColor,
                              glassBorderColor,
                              isContract: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. NAVIGATION DOCK
          Positioned(
            bottom: 20,
            left: 40,
            right: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: _isDarkMode
                        ? const Color(0xFF1E222B).withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: glassBorderColor),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. Dashboard (Accueil)
                      _buildNavIcon(Icons.dashboard_rounded, true, _isDarkMode),

                      // 2. Locataires
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TenantListScreen(),
                            ),
                          );
                        },
                        child: _buildNavIcon(
                          Icons.people_alt_rounded,
                          false,
                          _isDarkMode,
                        ),
                      ),

                      // 3. Propriétés (Finances/Portefeuille)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PropertiesScreen(),
                            ),
                          );
                        },
                        child: _buildNavIcon(
                          Icons.account_balance_wallet_rounded,
                          false,
                          _isDarkMode,
                        ),
                      ),

                      // 4. Gestion / Maintenance (Settings)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MaintenanceAdminScreen(),
                            ),
                          );
                        },
                        child: _buildNavIcon(
                          Icons.settings_rounded,
                          false,
                          _isDarkMode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS HELPERS ---

  Widget _buildGlassStatCard(
    String title,
    String percentage,
    String amount,
    IconData icon,
    Color color,
    Color cardColor,
    Color textColor,
    Color borderColor, {
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAlert ? color.withValues(alpha: 0.3) : borderColor,
        ),
        boxShadow: _isDarkMode
            ? []
            : [
                BoxShadow(
                  color: color.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            amount,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerCard(
    String name,
    String appt,
    String status,
    String debt,
    Color cardColor,
    Color textColor,
    Color borderColor, {
    bool isContract = false,
  }) {
    Color accentColor = isContract ? Colors.orangeAccent : Colors.redAccent;
    return Container(
      width: 160,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: _isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: accentColor.withValues(alpha: 0.1),
                child: Icon(
                  isContract ? Icons.history_edu : Icons.priority_high_rounded,
                  color: accentColor,
                  size: 14,
                ),
              ),
              const Spacer(),
              Text(
                appt,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            name,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            status,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              debt,
              style: TextStyle(
                color: accentColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: isActive
          ? BoxDecoration(
              color: AppTheme.brickOrange,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.brickOrange.withValues(alpha: 0.4),
                  blurRadius: 10,
                ),
              ],
            )
          : null,
      child: Icon(
        icon,
        color: isActive
            ? Colors.white
            : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
        size: 24,
      ),
    );
  }
}
