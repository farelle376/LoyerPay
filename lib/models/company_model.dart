class CompanyModel {
  final int id; // id_entreprise
  final String name; // nom_entreprise
  final String email; // email_entreprise
  final String? phone; // telephone_entreprise
  final String? address; // adresse_entreprise
  final String? logoUrl; // logo_url

  final String sector; // secteur_activite
  final String status; // statut (actif, suspendu...)
  final String plan; // plan_abonnement

  final DateTime? subscriptionExpiry; // date_expiration_abonnement
  final Map<String, dynamic>? paymentConfig; // config_paiement (JSON/Array)

  CompanyModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.logoUrl,
    required this.sector,
    required this.status,
    required this.plan,
    this.subscriptionExpiry,
    this.paymentConfig,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id_entreprise'] ?? 0,
      name: json['nom_entreprise'] ?? 'Entreprise',
      email: json['email_entreprise'] ?? '',
      phone: json['telephone_entreprise'],
      address: json['adresse_entreprise'],
      logoUrl: json['logo_url'],

      sector: json['secteur_activite'] ?? 'Immobilier',
      status: json['statut'] ?? 'actif',
      plan: json['plan_abonnement'] ?? 'standard',

      // Gestion de la date (Laravel envoie souvent YYYY-MM-DD pour les champs 'date')
      subscriptionExpiry: json['date_expiration_abonnement'] != null
          ? DateTime.tryParse(json['date_expiration_abonnement'])
          : null,

      // Gestion du JSON de config
      paymentConfig: json['config_paiement'] is Map
          ? Map<String, dynamic>.from(json['config_paiement'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_entreprise': id,
      'nom_entreprise': name,
      'email_entreprise': email,
      'telephone_entreprise': phone,
      'adresse_entreprise': address,
      'logo_url': logoUrl,
      'secteur_activite': sector,
      'statut': status,
      'plan_abonnement': plan,
      'date_expiration_abonnement': subscriptionExpiry?.toIso8601String().split(
        'T',
      )[0],
      'config_paiement': paymentConfig,
    };
  }
}
