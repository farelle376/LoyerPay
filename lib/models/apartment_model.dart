class ApartmentModel {
  // 1. ATTRIBUTS
  final int id; // id_appartement
  final int propertyId; // id_propriete
  final String unitNumber; // numero_appartement
  final String floor; // etage (String car peut être "RDC", "1er", etc.)
  final int rooms; // nombre_pieces
  final int bedrooms; // nombre_chambres
  final double area; // superficie (decimal)
  final String type; // type_appartement (Studio, T2, T3...)

  // Finances
  final double rentPrice; // prix_loyer
  final double deposit; // caution
  final double monthlyCharges; // charges_mensuelles

  // Détails & Médias
  final List<String> amenities; // equipements_internes (cast array)
  final String status; // statut (libre, occupe, travaux)
  final String description; // description
  final List<String> photos; // photos_url (cast array)

  // Relation (Optionnel, si tu charges avec 'with:propriete')
  // final PropertyModel? property;

  ApartmentModel({
    required this.id,
    required this.propertyId,
    required this.unitNumber,
    required this.floor,
    required this.rooms,
    required this.bedrooms,
    required this.area,
    required this.type,
    required this.rentPrice,
    required this.deposit,
    required this.monthlyCharges,
    required this.amenities,
    required this.status,
    required this.description,
    required this.photos,
  });

  // 2. FROM JSON (Lecture depuis Laravel)
  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      id: json['id_appartement'] ?? 0,
      propertyId: json['id_propriete'] ?? 0,
      unitNumber: json['numero_appartement'] ?? '',
      // 'etage' peut arriver en int ou string du backend, on force en String
      floor: json['etage']?.toString() ?? 'RDC',

      rooms: json['nombre_pieces'] ?? 0,
      bedrooms: json['nombre_chambres'] ?? 0,

      // Conversion sécurisée des décimaux (parfois reçus en String "50000.00")
      area: double.tryParse(json['superficie']?.toString() ?? '0') ?? 0.0,
      type: json['type_appartement'] ?? 'Standard',

      rentPrice: double.tryParse(json['prix_loyer']?.toString() ?? '0') ?? 0.0,
      deposit: double.tryParse(json['caution']?.toString() ?? '0') ?? 0.0,
      monthlyCharges:
          double.tryParse(json['charges_mensuelles']?.toString() ?? '0') ?? 0.0,

      // Gestion des Arrays JSON pour les équipements
      amenities: json['equipements_internes'] != null
          ? List<String>.from(json['equipements_internes'])
          : [],

      status: json['statut'] ?? 'libre',
      description: json['description'] ?? '',

      // Gestion des Photos
      photos: json['photos_url'] != null
          ? List<String>.from(json['photos_url'])
          : [],
    );
  }

  // 3. TO JSON (Envoi vers Laravel)
  Map<String, dynamic> toJson() {
    return {
      'id_appartement': id,
      'id_propriete': propertyId,
      'numero_appartement': unitNumber,
      'etage': floor,
      'nombre_pieces': rooms,
      'nombre_chambres': bedrooms,
      'superficie': area,
      'type_appartement': type,
      'prix_loyer': rentPrice,
      'caution': deposit,
      'charges_mensuelles': monthlyCharges,
      'equipements_internes': amenities,
      'statut': status,
      'description': description,
      'photos_url': photos,
    };
  }

  // 4. HELPERS (Getters calculés comme dans ton modèle PHP)

  // Équivalent de getLoyerTotalAttribute
  double get totalRent => rentPrice + monthlyCharges;

  // Helper pour l'affichage photo principale (sécurité si liste vide)
  String get coverImage {
    if (photos.isNotEmpty) return photos.first;
    return 'https://via.placeholder.com/400x300?text=Pas+d+image'; // Image par défaut
  }

  // Helper pour savoir si c'est occupé
  bool get isOccupied => status.toLowerCase() == 'occupe';
}
