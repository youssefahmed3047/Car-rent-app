import 'package:car_rent_app/Core/car_id_provider.dart';
import 'package:car_rent_app/Core/car.dart';
import 'package:car_rent_app/Core/hive_service.dart';
import 'package:car_rent_app/Features/car_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CarCard extends StatefulWidget {
  final String carId;
  final Car car;
  final Future<String> ownername;
  final bool isFavorit;

  const CarCard({
    super.key,
    required this.car,
    required this.ownername,
    required this.isFavorit,
    required this.carId,
  });

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorit || HiveService.isFavorite(widget.car);
  }

  @override
  void didUpdateWidget(covariant CarCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.car != widget.car ||
        oldWidget.isFavorit != widget.isFavorit) {
      isFavorite = widget.isFavorit || HiveService.isFavorite(widget.car);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<CarIDProvider>().changeCarId(widget.carId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CarPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.car.images[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.car.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.car.price} EGP Per Day',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15.sp,
                      ),
                    ),
                    FutureBuilder<String>(
                      future: widget.ownername,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Loading...',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15.sp,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text(
                            'Error',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15.sp,
                            ),
                          );
                        }

                        return Text(
                          snapshot.data ?? 'Unknown',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15.sp,
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.car.location,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15.sp,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final newFavoriteState = !isFavorite;

                            setState(() {
                              isFavorite = newFavoriteState;
                            });

                            if (newFavoriteState) {
                              final ownerName = await widget.ownername;
                              await HiveService.addFavorite(
                                car: widget.car,
                                ownerName: ownerName,
                                carId: widget.carId,
                              );
                            } else {
                              await HiveService.removeFavorite(widget.car);
                            }
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
