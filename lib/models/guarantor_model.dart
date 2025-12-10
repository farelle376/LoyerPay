class GuarantorModel {
  final int id; // id_garant
  final int contractId; // id_contrat

  final String lastName; // nom
  final String firstName; // prenom
  final String? phone; // telephone
  final String? email; // email

  final String profession; // profession
  final String? employer; // employeur
  final double monthlyIncome; // revenu_mensuel (decimal)

  final String? idType; // piece_identite_type
  final String? idNumber; // piece_identite_numero
  final String? idUrl; // piece_identite_url

  GuarantorModel({
    required this.id,
    required this.contractId,
    required this.lastName,
    required this.firstName,
    this.phone,
    this.email,
    required this.profession,
    this.employer,
    required this.monthlyIncome,
    this.idType,
    this.idNumber,
    this.idUrl,
  });

  factory GuarantorModel.fromJson(Map<String, dynamic> json) {
    return GuarantorModel(
      id: json['id_garant'] ?? 0,
      contractId: json['id_contrat'] ?? 0,
      lastName: json['nom'] ?? '',
      firstName: json['prenom'] ?? '',
      phone: json['telephone'],
      email: json['email'],
      profession: json['profession'] ?? '',
      employer: json['employeur'],

      // Conversion sécurisée Decimal -> Double
      monthlyIncome:
          double.tryParse(json['revenu_mensuel']?.toString() ?? '0') ?? 0.0,

      idType: json['piece_identite_type'],
      idNumber: json['piece_identite_numero'],
      idUrl: json['piece_identite_url'],
    );
  }

  // Helper UI (comme getNomCompletAttribute)
  String get fullName => "$firstName $lastName";
}
