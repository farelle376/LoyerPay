import 'dart:convert';
import 'dart:io'; // Pour détecter la plateforme (Android/iOS)

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart'; // Assure-toi que ce fichier existe bien

class ApiService {
  // 1. DÉTECTION AUTOMATIQUE DE L'IP
  // Android Emulator utilise 10.0.2.2 pour accéder au localhost de l'ordi.
  // iOS Simulator ou Web utilise localhost.
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api'; // iOS ou autre
    // Si tu testes sur un VRAI téléphone en USB, remplace par l'IP de ton PC
    // return 'http://192.168.1.15:8000/api';
  }

  // Stockage sécurisé pour le Token
  final _storage = const FlutterSecureStorage();

  // --- AUTHENTIFICATION ---

  Future<UserModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("Login Status: ${response.statusCode}"); // Debug
      print("Login Body: ${response.body}"); // Debug

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 1. Sauvegarder le token
        await _storage.write(key: 'token', value: data['token']);

        // 2. Retourner l'utilisateur (Laravel renvoie 'user')
        return UserModel.fromJson(data['user']);
      } else {
        // Erreur API (ex: Mauvais mot de passe)
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      throw Exception('Impossible de se connecter : $e');
    }
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      print("Erreur logout (ignorable): $e");
    } finally {
      // Dans tous les cas, on supprime le token localement
      await _storage.delete(key: 'token');
    }
  }

  // --- MÉTHODES GÉNÉRIQUES (GET, POST) ---

  // Pour récupérer des données (ex: Dashboard, Tickets...)
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']; // Laravel renvoie souvent { status: true, data: ... }
    } else {
      throw Exception('Erreur GET $endpoint: ${response.statusCode}');
    }
  }

  // Pour envoyer des données (ex: Payer, Créer Ticket)
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur POST $endpoint: ${response.body}');
    }
  }

  // --- HELPER HEADERS ---
  // Ajoute automatiquement le Token à chaque requête
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
