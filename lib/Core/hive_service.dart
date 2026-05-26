import 'package:car_rent_app/Core/car.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String favoritesBoxName = 'Favorites';

  static Box get favoritesBox => Hive.box(favoritesBoxName);

  static String favoriteKey(Car car) {
    if (car.carId.isNotEmpty) return car.carId;

    return '${car.owner}_${car.name}_${car.location}';
  }

  static bool isFavorite(Car car) {
    return favoritesBox.containsKey(favoriteKey(car));
  }

  static Future<void> addFavorite({
    required Car car,
    required String ownerName,
    required String carId,
  }) async {
    await favoritesBox.put(favoriteKey(car), {
      'car_id': carId,
      'name': car.name,
      'price': car.price,
      'location': car.location,
      'owner': car.owner,
      'ownerName': ownerName,
      'description': car.description,
      'images': car.images,
    });
  }

  static Future<void> removeFavorite(Car car) async {
    await favoritesBox.delete(favoriteKey(car));
  }

  static List<Map<String, dynamic>> getFavorites() {
    return favoritesBox.values
        .whereType<Map>()
        .map((favorite) => Map<String, dynamic>.from(favorite))
        .toList();
  }

  static Car carFromFavorite(Map<String, dynamic> favorite) {
    final price = favorite['price'];

    return Car(
      name: favorite['name'] ?? '',
      price: price is num ? price.toDouble() : 0,
      location: favorite['location'] ?? '',
      owner: favorite['owner'] ?? '',
      description: favorite['description'] ?? '',
      images: List.from(favorite['images'] ?? []),
      carId: favorite['car_id'] ?? '',
    );
  }
}
