import 'package:car_rent_app/Core/car_id_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CarIDProvider stores the selected car id', () {
    final provider = CarIDProvider();

    provider.changeCarId('car-1');

    expect(provider.carId, 'car-1');
  });
}
