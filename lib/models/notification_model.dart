class NotificationModel {
  final int id; // id_notification
  final int userId; // id_utilisateur

  final String type; // type_notification (echeance_loyer, etc.)
  final String title; // titre
  final String message; // message
  final String? link; // lien_redirection

  final bool isRead; // est_lue (boolean casté)
  final DateTime? readAt; // date_lecture
  final DateTime createdAt; // date_creation

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.link,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id_notification'] ?? 0,
      userId: json['id_utilisateur'] ?? 0,

      type: json['type_notification'] ?? 'info',
      title: json['titre'] ?? 'Notification',
      message: json['message'] ?? '',
      link: json['lien_redirection'],

      // Laravel cast boolean : true/false ou 1/0
      isRead: json['est_lue'] == true || json['est_lue'] == 1,

      readAt: json['date_lecture'] != null
          ? DateTime.tryParse(json['date_lecture'])
          : null,

      createdAt:
          DateTime.tryParse(json['date_creation'] ?? '') ?? DateTime.now(),
    );
  }

  // Helper pour l'affichage (Mapping des types Laravel vers des textes UI)
  String get typeLabel {
    switch (type) {
      case 'echeance_loyer':
        return 'Échéance de loyer';
      case 'retard_paiement':
        return 'Retard de paiement';
      case 'probleme_signe':
        return 'Problème signalé';
      case 'message_nouveau':
        return 'Nouveau message';
      case 'contrat_expiration':
        return 'Contrat expirant';
      case 'paiement_confirmé':
        return 'Paiement confirmé';
      default:
        return 'Information';
    }
  }
}
