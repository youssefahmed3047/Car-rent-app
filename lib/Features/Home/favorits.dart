import 'package:car_rent_app/Core/car.dart';
import 'package:car_rent_app/Core/hive_service.dart';
import 'package:car_rent_app/Shared/car_card.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Favorits extends StatelessWidget {
  const Favorits({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const SizedBox(), title: const Text('Favorites')),
      body: ValueListenableBuilder(
        valueListenable: HiveService.favoritesBox.listenable(),
        builder: (context, box, child) {
          final favorites = HiveService.getFavorites();

          return GridView.builder(
            itemCount: favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.96,
            ),
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              final Car car = HiveService.carFromFavorite(favorite);

              return CarCard(
                car: car,
                ownername: Future.value(favorite['ownerName'] ?? ''),
                isFavorit: true,
                carId: car.carId,
              );
            },
          );
        },
      ),
    );
  }
}
