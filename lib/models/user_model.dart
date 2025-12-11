class UserModel {
  // 1. ATTRIBUTS (On utilise le camelCase en Dart, mais on mappera avec le snake_case du JSON)
  final int id; // id_utilisateur
  final int? companyId; // id_entreprise (peut être null pour un super admin)
  final String lastName; // nom
  final String firstName; // prenom
  final String email; // email
  final String? phone; // telephone
  final String role; // role (locataire, directeur, etc.)
  final String? photoUrl; // photo_url
  final DateTime? birthDate; // date_naissance
  final String? gender; // genre
  final String status; // statut (ex: 'actif', 'suspendu')
  final Map<String, dynamic>?
  preferences; // preferences (cast array en Laravel)
  final DateTime? lastLogin; // dernier_login

  // Constructeur
  UserModel({
    required this.id,
    this.companyId,
    required this.lastName,
    required this.firstName,
    required this.email,
    this.phone,
    required this.role,
    this.photoUrl,
    this.birthDate,
    this.gender,
    this.status = 'actif', // Valeur par défaut prudente
    this.preferences,
    this.lastLogin,
  });

  // 2. FROM JSON (Lecture depuis Laravel)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0, // <--- ATTENTION : Mapping clé primaire
      companyId: json['id_entreprise'],
      lastName: json['nom'] ?? '',
      firstName: json['prenom'] ?? '',
      email: json['email'] ?? '',
      phone: json['telephone'],
      role: json['role'] ?? 'locataire',
      photoUrl: json['photo_url'],

      // Gestion des Dates (Laravel envoie souvent "YYYY-MM-DD" ou ISO8601)
      birthDate: json['date_naissance'] != null
          ? DateTime.tryParse(json['date_naissance'])
          : null,

      gender: json['genre'],
      status: json['statut'] ?? 'actif',

      // Gestion du JSON/Array (preferences)
      preferences: json['preferences'] is Map
          ? Map<String, dynamic>.from(json['preferences'])
          : null, // Si c'est null ou mal formaté

      lastLogin: json['dernier_login'] != null
          ? DateTime.tryParse(json['dernier_login'])
          : null,
    );
  }

  // 3. TO JSON (Envoi vers Laravel pour mise à jour)
  Map<String, dynamic> toJson() {
    return {
      'id_utilisateur': id, // On renvoie la bonne clé pour Laravel
      'id_entreprise': companyId,
      'nom': lastName,
      'prenom': firstName,
      'email': email,
      'telephone': phone,
      'role': role,
      'photo_url': photoUrl,
      // Formatage date pour MySQL (YYYY-MM-DD)
      'date_naissance': birthDate?.toIso8601String().split('T')[0],
      'genre': gender,
      'statut': status,
      'preferences': preferences,
      // On n'envoie généralement pas 'dernier_login' car le backend le gère
    };
  }

  // 4. HELPERS (Getters intelligents pour le code Flutter)

  // Nom complet pour l'affichage (ex: "Mamadou DIOP")
  String get fullName => "$firstName ${lastName.toUpperCase()}";

  // Vérifications de rôle (Identique à ton modèle PHP)
  bool get isTenant => role == 'locataire';
  bool get isManager => role == 'gestionnaire';
  bool get isDirector => role == 'directeur';
  bool get isSystemAdmin => role == 'admin_systeme';

  // Helper pour savoir si c'est un "Admin" au sens large (accès dashboard admin)
  bool get hasAdminAccess => isDirector || isManager || isSystemAdmin;
}
