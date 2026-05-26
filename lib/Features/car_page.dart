import 'package:car_rent_app/Core/car_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarPage extends StatelessWidget {
  const CarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carId = context.watch<CarIDProvider>().carId;

    return Scaffold(key: ValueKey(carId));
  }
}
