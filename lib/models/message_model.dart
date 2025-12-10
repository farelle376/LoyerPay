class MessageModel {
  final int id; // id_message
  final int senderId; // id_expediteur
  final int? receiverId; // id_destinataire
  final int? companyId; // id_entreprise (pour le contexte)

  final String type; // type_message (individuel, collectif...)
  final String? subject; // objet
  final String content; // contenu
  final List<String> attachments; // pieces_jointes (array casté)

  final String readStatus; // statut_lecture (lu, non_lu)
  final String sentVia; // envoye_via (email, app, sms)

  final DateTime sentAt; // date_envoi

  // Helper local (non BDD) pour l'UI du chat
  bool isMe;

  MessageModel({
    required this.id,
    required this.senderId,
    this.receiverId,
    this.companyId,
    this.type = 'individuel',
    this.subject,
    required this.content,
    required this.attachments,
    this.readStatus = 'non_lu',
    this.sentVia = 'app',
    required this.sentAt,
    this.isMe = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, {int? myUserId}) {
    final sender = json['id_expediteur'] ?? 0;
    return MessageModel(
      id: json['id_message'] ?? 0,
      senderId: sender,
      receiverId: json['id_destinataire'],
      companyId: json['id_entreprise'],

      type: json['type_message'] ?? 'individuel',
      subject: json['objet'],
      content: json['contenu'] ?? '',

      // Gestion des pièces jointes (Array)
      attachments: json['pieces_jointes'] != null
          ? List<String>.from(json['pieces_jointes'])
          : [],

      readStatus: json['statut_lecture'] ?? 'non_lu',
      sentVia: json['envoye_via'] ?? 'app',

      sentAt: DateTime.tryParse(json['date_envoi'] ?? '') ?? DateTime.now(),

      // Déduction de l'émetteur
      isMe: myUserId != null ? sender == myUserId : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_expediteur': senderId,
      'id_destinataire': receiverId,
      'id_entreprise': companyId,
      'type_message': type,
      'objet': subject,
      'contenu': content,
      'pieces_jointes': attachments,
      'envoye_via': sentVia,
      // 'statut_lecture' et 'date_envoi' gérés par le backend
    };
  }

  // Helper: Est lu ?
  bool get isRead => readStatus == 'lu';
}
