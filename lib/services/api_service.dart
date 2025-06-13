import 'package:flutter_application_1/models/character.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api/character';
}

class CharacterService {
  static const String baseUrl = 'https://rickandmortyapi.com/api/character';

  static Future<List<Character>> getCharacters({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/?page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  static Future<Character> getCharacterById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Character.fromJson(data);
    } else {
      throw Exception('Failed to load character');
    }
  }
}
