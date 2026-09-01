class Plant {
  final String id;
  final String name;
  final String species;
  final String imageUrl;
  final String description;
  final DateTime lastWatered;
  final DateTime nextWatering;
  final int healthScore;
  final List<String> careTips;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.imageUrl,
    required this.description,
    required this.lastWatered,
    required this.nextWatering,
    required this.healthScore,
    required this.careTips,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      lastWatered: DateTime.parse(json['lastWatered']),
      nextWatering: DateTime.parse(json['nextWatering']),
      healthScore: json['healthScore'],
      careTips: List<String>.from(json['careTips']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'imageUrl': imageUrl,
      'description': description,
      'lastWatered': lastWatered.toIso8601String(),
      'nextWatering': nextWatering.toIso8601String(),
      'healthScore': healthScore,
      'careTips': careTips,
    };
  }
}
