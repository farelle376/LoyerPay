import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
// IMPORTS PDF & FICHIERS
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // On utilise 'pw' pour les widgets PDF
import 'package:printing/printing.dart';

import '../../config/theme.dart';

class ReceiptDetailScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const ReceiptDetailScreen({
    super.key,
    this.transaction = const {
      "id": "TXN-8839201",
      "date": "05 Déc 2025, 10:42",
      "amount": "50.000",
      "method": "MTN Mobile Money",
      "period": "Décembre 2025",
      "tenant": "M. Koffi",
      "property": "Appt A12 - Rés. Palmiers",
    },
  });

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- LE CERVEAU DU DESIGN PDF 🎨 ---
  Future<Uint8List> _generatePdfBytes() async {
    final doc = pw.Document();

    // Définition des couleurs pour le PDF (Format PdfColor)
    final brandBlue = PdfColor.fromInt(0xFF1A2B49); // Ton DarkBlue
    final brandOrange = PdfColor.fromInt(0xFFE55D2B); // Ton BrickOrange
    final lightGrey = PdfColor.fromInt(0xFFF2F6F9);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0), // Pleine page pour les bandeaux
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // 1. EN-TÊTE COLORÉ (HEADER)
              pw.Container(
                height: 120,
                padding: const pw.EdgeInsets.symmetric(horizontal: 40),
                decoration: pw.BoxDecoration(color: brandBlue),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          "LoyerPay ",
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "Gestion Immobilière & Syndic",
                          style: pw.TextStyle(
                            color: PdfColors.grey300,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          "QUITTANCE DE LOYER",
                          style: pw.TextStyle(
                            color: brandOrange,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "N° ${widget.transaction['id']}",
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 12,
                          ),
                        ),
                        pw.Text(
                          "Date: ${widget.transaction['date'].split(',')[0]}",
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. CORPS DU DOCUMENT
              pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Info Locataire & Propriété
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(15),
                            decoration: pw.BoxDecoration(
                              color: lightGrey,
                              borderRadius: pw.BorderRadius.circular(10),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "LOCATAIRE",
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.grey700,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  widget.transaction['tenant'],
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: brandBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.SizedBox(width: 20),
                        pw.Expanded(
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(15),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey300),
                              borderRadius: pw.BorderRadius.circular(10),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "BIEN LOUÉ",
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.grey700,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  widget.transaction['property'],
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 40),

                    // 3. TABLEAU DÉTAILS (STYLE MODERNE)
                    pw.Container(
                      width: double.infinity,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(
                            color: PdfColors.grey300,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const pw.EdgeInsets.only(bottom: 10),
                      child: pw.Text(
                        "DÉTAILS DU PAIEMENT",
                        style: pw.TextStyle(
                          color: brandBlue,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 10),

                    _buildPdfRow(
                      "Période concernée",
                      widget.transaction['period'],
                    ),
                    pw.Divider(color: PdfColors.grey200),
                    _buildPdfRow(
                      "Moyen de paiement",
                      widget.transaction['method'],
                    ),
                    pw.Divider(color: PdfColors.grey200),
                    _buildPdfRow(
                      "Statut",
                      "PAYÉ",
                      color: PdfColors.green700,
                      isBold: true,
                    ),

                    pw.SizedBox(height: 30),

                    // 4. TOTAL (GROS CADRE)
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      decoration: pw.BoxDecoration(
                        color: brandBlue,
                        borderRadius: pw.BorderRadius.circular(15),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "TOTAL PAYÉ",
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            "${widget.transaction['amount']} FCFA",
                            style: pw.TextStyle(
                              color: brandOrange,
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 60),

                    // 5. SIGNATURE ET CACHET
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "Note importante :",
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Ce document est une preuve de paiement\nnumérique valable juridiquement.",
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text(
                              "Signature & Cachet",
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Container(
                              width: 120,
                              height: 60,
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                  color: brandOrange,
                                  width: 2,
                                ),
                                borderRadius: pw.BorderRadius.circular(10),
                              ),
                              child: pw.Center(
                                child: pw.Transform.rotate(
                                  angle: -0.2,
                                  child: pw.Text(
                                    "LoyerPay\nPAYÉ",
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      color: brandOrange,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Spacer(),
              // PIED DE PAGE
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                color: lightGrey,
                child: pw.Center(
                  child: pw.Text(
                    "LoyerPay SA - Siège : Cotonou, Haie Vive - Tél : +229 97 00 00 00 - contact@loyerpay.com",
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    return await doc.save();
  }

  // Helper pour les lignes du PDF
  pw.Widget _buildPdfRow(
    String label,
    String value, {
    PdfColor? color,
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: PdfColors.grey700)),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color ?? PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  // --- FONCTIONS ACTIONS (Share & Download) ---
  Future<void> _sharePdf() async {
    final bytes = await _generatePdfBytes();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Recu_${widget.transaction['id']}.pdf',
    );
  }

  Future<void> _downloadAndOpenPdf() async {
    try {
      final bytes = await _generatePdfBytes();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/Recu_${widget.transaction['id']}.pdf');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reçu téléchargé ! ✅"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- L'INTERFACE UTILISATEUR (Vue Ecran) ---
    // (J'ai gardé ton interface écran préférée, mais le PDF généré sera celui défini plus haut)
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Détails de la transaction",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.darkBlue, Color(0xFF2E5A9E)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: _buildReceiptCard(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _downloadAndOpenPdf,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brickOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 10,
                            ),
                            icon: const Icon(Icons.download_rounded, size: 24),
                            label: const Text(
                              "TÉLÉCHARGER LE REÇU (PDF)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _sharePdf,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.share, size: 24),
                            label: const Text(
                              "PARTAGER",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
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
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Paiement Réussi !",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${widget.transaction['amount']} FCFA",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkBlue,
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Divider(),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "DÉTAILS",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildDetailRow("Référence", widget.transaction['id']),
              _buildDetailRow("Date", widget.transaction['date']),
              _buildDetailRow("Moyen", widget.transaction['method']),
              _buildDetailRow(
                "Période",
                widget.transaction['period'],
                isBold: true,
              ),
              _buildDetailRow("Bien", widget.transaction['property']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? AppTheme.darkBlue : Colors.black87,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
