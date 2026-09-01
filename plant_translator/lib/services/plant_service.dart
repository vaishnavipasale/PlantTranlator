import '../models/plant.dart';

class PlantService {
  // Mock data for demonstration
  static List<Plant> getMockPlants() {
    return [
      Plant(
        id: '1',
        name: 'Monstera Deliciosa',
        species: 'Monstera deliciosa',
        imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400',
        description: 'A popular tropical plant known for its unique split leaves.',
        lastWatered: DateTime.now().subtract(const Duration(days: 3)),
        nextWatering: DateTime.now().add(const Duration(days: 4)),
        healthScore: 92,
        careTips: [
          'Water every 1-2 weeks',
          'Keep in indirect sunlight',
          'Mist leaves regularly',
          'Use well-draining soil',
        ],
      ),
      Plant(
        id: '2',
        name: 'Snake Plant',
        species: 'Sansevieria trifasciata',
        imageUrl: 'https://images.unsplash.com/photo-1593482892240-a2e276794a27?w=400',
        description: 'An easy-care succulent with tall, sword-like leaves.',
        lastWatered: DateTime.now().subtract(const Duration(days: 7)),
        nextWatering: DateTime.now().add(const Duration(days: 7)),
        healthScore: 88,
        careTips: [
          'Water every 2-3 weeks',
          'Tolerates low light',
          'Allow soil to dry between waterings',
          'Avoid overwatering',
        ],
      ),
      Plant(
        id: '3',
        name: 'Peace Lily',
        species: 'Spathiphyllum wallisii',
        imageUrl: 'https://images.unsplash.com/photo-1593691509543-c55fb32d8de5?w=400',
        description: 'Elegant flowering plant with white blooms and glossy leaves.',
        lastWatered: DateTime.now().subtract(const Duration(days: 2)),
        nextWatering: DateTime.now().add(const Duration(days: 3)),
        healthScore: 95,
        careTips: [
          'Keep soil moist but not soggy',
          'Bright indirect light',
          'High humidity preferred',
          'Remove faded flowers',
        ],
      ),
      Plant(
        id: '4',
        name: 'Pothos',
        species: 'Epipremnum aureum',
        imageUrl: 'https://images.unsplash.com/photo-1600411833196-7c1f6b1a8b90?w=400',
        description: 'Versatile trailing vine with heart-shaped leaves.',
        lastWatered: DateTime.now().subtract(const Duration(days: 5)),
        nextWatering: DateTime.now().add(const Duration(days: 5)),
        healthScore: 90,
        careTips: [
          'Water when top inch is dry',
          'Thrives in various light conditions',
          'Prune to encourage bushiness',
          'Easy to propagate',
        ],
      ),
    ];
  }

  Future<List<Plant>> getPlants() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockPlants();
  }

  Future<Plant?> getPlantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return getMockPlants().firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }
}
