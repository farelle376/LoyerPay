import 'package:intl/intl.dart'; // Pour formater les périodes

class ReportModel {
  final int id; // id_rapport
  final int companyId; // id_entreprise
  final int generatedBy; // genere_par (user id)

  final String type; // type_rapport
  final DateTime startDate; // periode_debut
  final DateTime endDate; // periode_fin

  final Map<String, dynamic> data; // donnees (JSON)
  final String? fileUrl; // fichier_url
  final DateTime? generatedAt; // date_generation

  ReportModel({
    required this.id,
    required this.companyId,
    required this.generatedBy,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.data,
    this.fileUrl,
    this.generatedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id_rapport'] ?? 0,
      companyId: json['id_entreprise'] ?? 0,
      generatedBy: json['genere_par'] ?? 0,
      type: json['type_rapport'] ?? 'financier',

      startDate:
          DateTime.tryParse(json['periode_debut'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['periode_fin'] ?? '') ?? DateTime.now(),

      // Conversion JSON Array
      data: json['donnees'] is Map
          ? Map<String, dynamic>.from(json['donnees'])
          : {},

      fileUrl: json['fichier_url'],
      generatedAt: json['date_generation'] != null
          ? DateTime.tryParse(json['date_generation'])
          : null,
    );
  }

  // Helper UI (Traduction getTypeLabelAttribute)
  String get typeLabel {
    switch (type) {
      case 'financier':
        return 'Rapport Financier';
      case 'occupation':
        return "Rapport d'Occupation";
      case 'maintenance':
        return 'Rapport de Maintenance';
      case 'performance':
        return 'Rapport de Performance';
      default:
        return type;
    }
  }

  // Helper UI (Traduction getPeriodeAttribute)
  String get formattedPeriod {
    final start = DateFormat('dd/MM/yyyy').format(startDate);
    final end = DateFormat('dd/MM/yyyy').format(endDate);
    return "$start - $end";
  }
}
