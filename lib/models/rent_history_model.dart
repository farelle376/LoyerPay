class RentHistoryModel {
  final int id; // id_historique
  final int contractId; // id_contrat
  final int initiatedByUserId; // initié_par (id utilisateur)

  final double oldRent; // ancien_loyer
  final double newRent; // nouveau_loyer

  final DateTime changeDate; // date_changement
  final String reason; // raison_changement

  RentHistoryModel({
    required this.id,
    required this.contractId,
    required this.initiatedByUserId,
    required this.oldRent,
    required this.newRent,
    required this.changeDate,
    required this.reason,
  });

  factory RentHistoryModel.fromJson(Map<String, dynamic> json) {
    return RentHistoryModel(
      id: json['id_historique'] ?? 0,
      contractId: json['id_contrat'] ?? 0,
      initiatedByUserId: json['initié_par'] ?? 0,

      oldRent: double.tryParse(json['ancien_loyer']?.toString() ?? '0') ?? 0.0,
      newRent: double.tryParse(json['nouveau_loyer']?.toString() ?? '0') ?? 0.0,

      changeDate:
          DateTime.tryParse(json['date_changement'] ?? '') ?? DateTime.now(),
      reason: json['raison_changement'] ?? 'Révision annuelle',
    );
  }

  // --- LOGIQUE METIER ---

  // Traduction de getDifferenceAttribute
  double get difference => newRent - oldRent;

  // Traduction de getPourcentageChangementAttribute
  double get percentageChange {
    if (oldRent == 0) return 0.0;
    return ((newRent - oldRent) / oldRent) * 100;
  }

  // Helper pour l'affichage (ex: "+ 5.000")
  String get formattedDifference {
    final sign = difference >= 0 ? '+' : '';
    return "$sign${difference.toStringAsFixed(0)}";
  }
}
