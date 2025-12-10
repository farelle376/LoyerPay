import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  String _selectedPeriod = "Cette Année";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rapports Financiers",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppTheme.brickOrange),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Export PDF en cours...")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FILTRES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Croissance",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPeriod,
                    items: ["Ce Mois", "Ce Trimestre", "Cette Année"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedPeriod = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // GRAPHIQUE BARRES (Revenus vs Dépenses)
            Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _bottomTitles,
                      ),
                    ),
                  ),
                  barGroups: _getBarGroups(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // TABLEAU BILAN
            const Text(
              "Bilan par Propriété",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBlue,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildReportRow(
                    "Résidence Palmiers",
                    "+ 2.5M",
                    "+ 15%",
                    true,
                  ),
                  const Divider(height: 1),
                  _buildReportRow("Villa Cocody", "+ 800K", "+ 5%", true),
                  const Divider(height: 1),
                  _buildReportRow(
                    "Studio B05",
                    "- 50K",
                    "- 2%",
                    false,
                  ), // Dépense travaux
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(6, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: (i + 1) * 2.0 + 3,
            color: AppTheme.darkBlue,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: (i + 1) * 1.5,
            color: Colors.grey.shade300,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  Widget _buildReportRow(
    String title,
    String amount,
    String percent,
    bool isPositive,
  ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              percent,
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _bottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(color: Colors.grey, fontSize: 10);
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'JAN';
      break;
    case 1:
      text = 'FÉV';
      break;
    case 2:
      text = 'MAR';
      break;
    case 3:
      text = 'AVR';
      break;
    case 4:
      text = 'MAI';
      break;
    case 5:
      text = 'JUI';
      break;
    default:
      text = '';
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(text, style: style),
  );
}
