import 'package:flutter_application_1/models/location.dart';
import 'package:flutter_application_1/models/origin.dart';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String url;
  final String image;
  final String created;
  final Origin origin;
  final Location location;
  final List<String> episode;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.url,
    required this.image,
    required this.created,
    required this.origin,
    required this.location,
    required this.episode,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      url: json['url'],
      image: json['image'],
      created: json['created'],
      origin: Origin.fromJson(json['origin']),
      location: Location.fromJson(json['location']),
      episode: List<String>.from(json['episode']),
    );
  }
}
