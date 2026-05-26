import 'package:flutter/foundation.dart';

class CarIDProvider extends ChangeNotifier {
  String? _carId;

  String? get carId => _carId;

  void changeCarId(String carId) {
    _carId = carId;
    notifyListeners();
  }
}
