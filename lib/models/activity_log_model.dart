class ActivityLogModel {
  final int id; // id_log
  final int userId; // id_utilisateur
  final int? companyId; // id_entreprise

  final String actionType; // type_action
  final String description; // description
  final String? ipAddress; // ip_adresse
  final String? userAgent; // user_agent
  final DateTime actionDate; // date_action

  ActivityLogModel({
    required this.id,
    required this.userId,
    this.companyId,
    required this.actionType,
    required this.description,
    this.ipAddress,
    this.userAgent,
    required this.actionDate,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id_log'] ?? 0,
      userId: json['id_utilisateur'] ?? 0,
      companyId: json['id_entreprise'],

      actionType: json['type_action'] ?? 'inconnu',
      description: json['description'] ?? '',
      ipAddress: json['ip_adresse'],
      userAgent: json['user_agent'],

      actionDate:
          DateTime.tryParse(json['date_action'] ?? '') ?? DateTime.now(),
    );
  }

  // Helper UI (Traduction getActionLabelAttribute)
  String get actionLabel {
    switch (actionType) {
      case 'connexion':
        return 'Connexion';
      case 'deconnexion':
        return 'Déconnexion';
      case 'creation':
        return 'Création';
      case 'modification':
        return 'Modification';
      case 'suppression':
        return 'Suppression';
      case 'paiement':
        return 'Paiement';
      case 'telechargement':
        return 'Téléchargement';
      default:
        return actionType;
    }
  }
}
