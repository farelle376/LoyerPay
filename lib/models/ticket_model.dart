class TicketModel {
  final int id; // id_probleme
  final int contractId; // id_contrat
  final int tenantId; // id_locataire

  final String category; // categorie (plomberie, electricite...)
  final String title; // titre
  final String description; // description
  final String urgency; // urgence
  final String status; // statut (nouveau, resolu...)

  final List<String> photos; // photos_url (array casté)

  final DateTime createdAt; // date_signalement (casté datetime)
  final DateTime? resolvedAt; // date_resolution
  final String? resolutionNotes; // notes_resolution
  final int? resolvedBy; // resolu_par

  TicketModel({
    required this.id,
    required this.contractId,
    required this.tenantId,
    required this.category,
    required this.title,
    required this.description,
    required this.urgency,
    required this.status,
    required this.photos,
    required this.createdAt,
    this.resolvedAt,
    this.resolutionNotes,
    this.resolvedBy,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id_probleme'] ?? 0,
      contractId: json['id_contrat'] ?? 0,
      tenantId: json['id_locataire'] ?? 0,

      category: json['categorie'] ?? 'Autre',
      title: json['titre'] ?? 'Signalement',
      description: json['description'] ?? '',
      urgency: json['urgence'] ?? 'moyenne',
      status: json['statut'] ?? 'nouveau',

      // Gestion des photos (Array JSON)
      photos: json['photos_url'] != null
          ? List<String>.from(json['photos_url'])
          : [],

      // date_signalement est dans $casts, Laravel l'envoie souvent en ISO8601
      createdAt:
          DateTime.tryParse(json['date_signalement'] ?? '') ?? DateTime.now(),

      resolvedAt: json['date_resolution'] != null
          ? DateTime.tryParse(json['date_resolution'])
          : null,
      resolutionNotes: json['notes_resolution'],
      resolvedBy: json['resolu_par'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_probleme': id,
      'id_contrat': contractId,
      'id_locataire': tenantId,
      'categorie': category,
      'titre': title,
      'description': description,
      'urgence': urgency,
      'statut': status,
      'photos_url': photos,
      // Les dates sont gérées par le backend ou formattées si besoin
    };
  }

  // Helper UI : Est-ce résolu ?
  bool get isResolved => status == 'resolu';
}
