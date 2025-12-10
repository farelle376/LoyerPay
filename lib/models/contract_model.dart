class ContractModel {
  // ATTRIBUTS (Mapping snake_case PHP -> camelCase Dart)
  final int id; // id
  final int tenantId; // id_locataire
  final int apartmentId; // id_appartement

  final DateTime startDate; // date_debut
  final DateTime endDate; // date_fin

  final double rentAmount; // montant_loyer (ou prix_loyer snapshot)
  final double deposit; // caution

  final String status; // statut (actif, termine, resilie)
  final String? fileUrl; // url_document (PDF)

  ContractModel({
    required this.id,
    required this.tenantId,
    required this.apartmentId,
    required this.startDate,
    required this.endDate,
    required this.rentAmount,
    required this.deposit,
    required this.status,
    this.fileUrl,
  });

  // FROM JSON
  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] ?? 0,
      tenantId: json['id_locataire'] ?? 0,
      apartmentId: json['id_appartement'] ?? 0,

      startDate: DateTime.tryParse(json['date_debut'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['date_fin'] ?? '') ?? DateTime.now(),

      rentAmount:
          double.tryParse(json['montant_loyer']?.toString() ?? '0') ?? 0.0,
      deposit: double.tryParse(json['caution']?.toString() ?? '0') ?? 0.0,

      status: json['statut'] ?? 'brouillon',
      fileUrl: json['url_document'], // Champ supposé pour le PDF
    );
  }

  // TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_locataire': tenantId,
      'id_appartement': apartmentId,
      'date_debut': startDate.toIso8601String().split('T')[0],
      'date_fin': endDate.toIso8601String().split('T')[0],
      'montant_loyer': rentAmount,
      'caution': deposit,
      'statut': status,
      'url_document': fileUrl,
    };
  }

  // --- LOGIQUE METIER (Traduction du PHP) ---

  // Traduction de getJoursRestantsAttribute
  int get remainingDays {
    final now = DateTime.now();
    // difference renvoie une Duration, on prend les jours
    return endDate.difference(now).inDays;
  }

  // Traduction de getEstActifAttribute
  bool get isActive {
    final now = DateTime.now();
    return status == 'actif' && now.isAfter(startDate) && now.isBefore(endDate);
  }
}
