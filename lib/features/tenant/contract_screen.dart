import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
// IMPORTS PDF & FICHIERS
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../config/theme.dart';

class ContractScreen extends StatefulWidget {
  final Map<String, dynamic> contractData;

  const ContractScreen({
    super.key,
    this.contractData = const {
      "id": "CTR-2023-0042",
      "startDate": "01/01/2023",
      "endDate": "31/12/2025",
      "type": "Habitation",
      "amount": "50.000",
      "deposit": "150.000",
      "tenant": "M. Koffi",
      "landlord": "FARI IMMO",
      "address": "Résidence Les Palmiers, Appt A12, Cotonou",
      "signedDate": "15 Décembre 2022",
    },
  });

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 100,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- MOTEUR PDF ---
  Future<Uint8List> _generatePdfBytes() async {
    final doc = pw.Document();

    // Couleurs PDF
    final brandBlue = PdfColor.fromInt(0xFF1A2B49);
    final lightBg = PdfColor.fromInt(0xFFF5F5F5);

    doc.addPage(
      pw.MultiPage(
        // MultiPage car un contrat peut être long
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // EN-TÊTE
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "FARI IMMO",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: brandBlue,
                    ),
                  ),
                  pw.Text(
                    "CONTRAT DE BAIL",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              "Réf: ${widget.contractData['id']}",
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 20),

            // ENCADRÉ PARTIES
            pw.Container(
              color: lightBg,
              padding: const pw.EdgeInsets.all(15),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _buildPdfParty(
                      "BAILLEUR",
                      widget.contractData['landlord'],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: _buildPdfParty(
                      "LOCATAIRE",
                      widget.contractData['tenant'],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // ARTICLES
            _buildPdfArticle(
              "OBJET DU CONTRAT",
              "Le Bailleur donne en location au Preneur les locaux situés à : ${widget.contractData['address']}.",
            ),
            _buildPdfArticle(
              "DURÉE",
              "Le bail est consenti pour une durée déterminée, du ${widget.contractData['startDate']} au ${widget.contractData['endDate']}.",
            ),
            _buildPdfArticle(
              "LOYER ET CHARGES",
              "Le présent bail est consenti moyennant un loyer mensuel de ${widget.contractData['amount']} FCFA, payable d'avance.",
            ),
            _buildPdfArticle(
              "DÉPÔT DE GARANTIE",
              "À titre de garantie, le Preneur verse la somme de ${widget.contractData['deposit']} FCFA.",
            ),

            pw.SizedBox(height: 40),

            // SIGNATURES
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfSignatureBox("Le Bailleur"),
                _buildPdfSignatureBox("Le Locataire"),
              ],
            ),

            pw.Spacer(),
            pw.Divider(),
            pw.Center(
              child: pw.Text(
                "Fait à Cotonou, le ${widget.contractData['signedDate']}",
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ];
        },
      ),
    );
    return await doc.save();
  }

  // Helpers PDF
  pw.Widget _buildPdfParty(String role, String name) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          role,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          name,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildPdfArticle(String title, String content) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "ARTICLE - $title",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            content,
            style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.5),
            textAlign: pw.TextAlign.justify,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfSignatureBox(String label) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
        pw.SizedBox(height: 5),
        pw.Container(
          width: 150,
          height: 60,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Center(
            child: pw.Text(
              "(Signature)",
              style: const pw.TextStyle(color: PdfColors.grey300, fontSize: 8),
            ),
          ),
        ),
      ],
    );
  }

  // --- ACTIONS ---
  Future<void> _sharePdf() async {
    final bytes = await _generatePdfBytes();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Contrat_${widget.contractData['id']}.pdf',
    );
  }

  Future<void> _downloadAndOpenPdf() async {
    try {
      final bytes = await _generatePdfBytes();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/Contrat_${widget.contractData['id']}.pdf');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Document ouvert ! 📄"),
            backgroundColor: Colors.green,
          ),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEFF5), // Fond gris bureau
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mon Bail",
          style: TextStyle(
            color: AppTheme.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppTheme.darkBlue),
            onPressed: _sharePdf,
          ),
        ],
      ),
      body: Column(
        children: [
          // LA FEUILLE DE PAPIER
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(opacity: _controller.value, child: child),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    5,
                  ), // Coins peu arrondis comme du papier
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Document
                        Center(
                          child: Column(
                            children: [
                              const Icon(
                                FontAwesomeIcons.fileSignature,
                                size: 40,
                                color: AppTheme.darkBlue,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "CONTRAT DE BAIL",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Serif',
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                "Réf. ${widget.contractData['id']}",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Divider(thickness: 2),
                        const SizedBox(height: 20),

                        // Résumé Clé
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FD),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              _buildSummaryRow(
                                "Loyer",
                                "${widget.contractData['amount']} FCFA",
                              ),
                              const SizedBox(height: 10),
                              _buildSummaryRow(
                                "Caution",
                                "${widget.contractData['deposit']} FCFA",
                              ),
                              const SizedBox(height: 10),
                              _buildSummaryRow(
                                "Échéance",
                                widget.contractData['endDate'],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Texte légal (Extrait)
                        const Text(
                          "ENTRE LES SOUSSIGNÉS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Entre l'entreprise ${widget.contractData['landlord']} (Bailleur) et M. ${widget.contractData['tenant']} (Preneur), il a été convenu ce qui suit concernant le bien situé à ${widget.contractData['address']}.",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            height: 1.6,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Le présent contrat est régi par les lois en vigueur. Le preneur s'engage à payer son loyer avant le 5 de chaque mois...",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            height: 1.6,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.justify,
                        ),

                        const SizedBox(height: 40),
                        // Fake Signatures
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Le Bailleur",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Signature_sample.svg/1200px-Signature_sample.svg.png",
                                  height: 40,
                                  width: 80,
                                  color: AppTheme.darkBlue,
                                ),
                              ],
                            ),
                            const Column(
                              children: [
                                Text(
                                  "Le Locataire",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "(Signé numériquement)",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // BOUTON FLOTTANT (Sticky Bottom)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloadAndOpenPdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBlue,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: const Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  "TÉLÉCHARGER L'ORIGINAL (PDF)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBlue,
          ),
        ),
      ],
    );
  }
}
