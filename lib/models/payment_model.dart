import 'package:intl/intl.dart'; // Nécessaire pour formater les dates (ex: "Décembre 2025")

class PaymentModel {
  final int id; // id
  final int contractId; // id_contrat

  final double amount; // montant
  final DateTime? paymentDate; // date_paiement (null si pas encore payé)
  final DateTime
  concernedMonth; // mois_concerne (Date de début du mois, ex: 2025-12-01)

  final String status; // statut (paye, en_attente, echoue)
  final String? method; // moyen_paiement (Mobile Money, Virement...)
  final String? reference; // reference_transaction

  PaymentModel({
    required this.id,
    required this.contractId,
    required this.amount,
    this.paymentDate,
    required this.concernedMonth,
    required this.status,
    this.method,
    this.reference,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,
      contractId: json['id_contrat'] ?? 0,
      amount: double.tryParse(json['montant']?.toString() ?? '0') ?? 0.0,

      paymentDate: json['date_paiement'] != null
          ? DateTime.tryParse(json['date_paiement'])
          : null,

      concernedMonth:
          DateTime.tryParse(json['mois_concerne'] ?? '') ?? DateTime.now(),

      status: json['statut'] ?? 'en_attente',
      method: json['moyen_paiement'],
      reference: json['reference_transaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_contrat': contractId,
      'montant': amount,
      'date_paiement': paymentDate?.toIso8601String(),
      'mois_concerne': concernedMonth.toIso8601String().split(
        'T',
      )[0], // YYYY-MM-DD
      'statut': status,
      'moyen_paiement': method,
      'reference_transaction': reference,
    };
  }

  // --- LOGIQUE METIER ---

  // Traduction de getMoisConcerneFormattedAttribute
  // Nécessite le package intl. Si tu ne l'as pas, utilise une liste de mois manuelle.
  String get formattedMonth {
    // Format: "Décembre 2025" (locale 'fr_FR' à configurer dans main.dart)
    return DateFormat.yMMMM('fr_FR').format(concernedMonth);
  }

  // Traduction de getEstEnRetardAttribute
  bool get isLate {
    final now = DateTime.now();
    // Si on est le mois suivant et que le statut est toujours 'en_attente'
    final startOfCurrentMonth = DateTime(now.year, now.month, 1);
    return concernedMonth.isBefore(startOfCurrentMonth) &&
        status == 'en_attente';
  }
}
