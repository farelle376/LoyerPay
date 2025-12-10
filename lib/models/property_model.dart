import 'apartment_model.dart'; // Importez le modèle enfant

class PropertyModel {
  // 1. ATTRIBUTS
  final int id; // id_propriete
  final int companyId; // id_entreprise
  final String name; // nom_propriete
  final String address; // adresse_complete
  final String city; // ville
  final String district; // quartier
  final String type; // type_propriete (Immeuble, Villa, etc.)

  final int floors; // nombre_etages
  final int constructionYear; // annee_construction
  final double area; // superficie

  final String description; // description
  final List<String> amenities; // equipements (array)
  final String status; // statut (actif, en_vente, etc.)

  // Géolocalisation (Peut être null si pas renseigné)
  final double? latitude;
  final double? longitude;

  final List<String> photos; // photos_url (array)

  // RELATION (Liste des appartements contenus dans cette propriété)
  final List<ApartmentModel> units; // relation hasMany 'appartements'

  PropertyModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.address,
    required this.city,
    required this.district,
    required this.type,
    required this.floors,
    required this.constructionYear,
    required this.area,
    required this.description,
    required this.amenities,
    required this.status,
    this.latitude,
    this.longitude,
    required this.photos,
    this.units = const [], // Par défaut liste vide
  });

  // 2. FROM JSON (Lecture depuis Laravel)
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id_propriete'] ?? 0,
      companyId: json['id_entreprise'] ?? 0,
      name: json['nom_propriete'] ?? 'Nom inconnu',
      address: json['adresse_complete'] ?? '',
      city: json['ville'] ?? '',
      district: json['quartier'] ?? '',
      type: json['type_propriete'] ?? 'Standard',

      floors: json['nombre_etages'] ?? 0,
      constructionYear: json['annee_construction'] ?? 0,
      area: double.tryParse(json['superficie']?.toString() ?? '0') ?? 0.0,

      description: json['description'] ?? '',

      // Gestion des Arrays JSON
      amenities: json['equipements'] != null
          ? List<String>.from(json['equipements'])
          : [],

      status: json['statut'] ?? 'actif',

      // Conversion sécurisée des coordonnées
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,

      photos: json['photos_url'] != null
          ? List<String>.from(json['photos_url'])
          : [],

      // Mapping de la relation 'appartements' si elle est incluse dans la réponse JSON
      units: json['appartements'] != null
          ? (json['appartements'] as List)
                .map((item) => ApartmentModel.fromJson(item))
                .toList()
          : [],
    );
  }

  // 3. TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id_propriete': id,
      'id_entreprise': companyId,
      'nom_propriete': name,
      'adresse_complete': address,
      'ville': city,
      'quartier': district,
      'type_propriete': type,
      'nombre_etages': floors,
      'annee_construction': constructionYear,
      'superficie': area,
      'description': description,
      'equipements': amenities,
      'statut': status,
      'latitude': latitude,
      'longitude': longitude,
      'photos_url': photos,
      // On n'envoie généralement pas les 'units' en update de propriété
    };
  }

  // 4. HELPERS (Pour l'UI)

  // Adresse complète (comme le getter PHP)
  String get fullAddress => "$address, $district, $city";

  // Image de couverture
  String get coverImage {
    if (photos.isNotEmpty) return photos.first;
    return 'https://via.placeholder.com/400x300?text=Fari+Immo';
  }

  // Calculs sur les unités (comme les getters PHP, mais côté client pour fluidité)
  int get totalUnits => units.length;

  int get occupiedUnits => units.where((u) => u.status == 'occupe').length;

  int get vacantUnits => units.where((u) => u.status == 'libre').length;

  // Pourcentage d'occupation (pour les stats Admin)
  double get occupancyRate {
    if (totalUnits == 0) return 0.0;
    return (occupiedUnits / totalUnits);
  }
}
