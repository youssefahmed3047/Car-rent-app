import 'package:car_rent_app/Core/car_id_provider.dart';
import 'package:car_rent_app/Features/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});
  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  Map<String, dynamic> car = {};
  Map<String, dynamic> owner = {};

  void getCar(String? carId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('cars')
        .doc(carId)
        .get();

    setState(() {
      car = {"id": snapshot.id, ...snapshot.data() as Map<String, dynamic>};
    });
  }

  void getOwnerName(String ownerId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(ownerId)
        .get();
    setState(() {
      owner = snapshot.data() as Map<String, dynamic>;
    });
  }

  @override
  void initState() {
    super.initState();
    final carId = context.read<CarIDProvider>().carId;
    getCar(carId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: car.isEmpty && owner.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListView(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(car['Car images'].length, (
                        index,
                      ) {
                        getOwnerName(car['Car owner']);
                        return Container(
                          width: 250.w,
                          height: 250.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            image: DecorationImage(
                              image: NetworkImage(car['Car images'][index]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      car['Car name'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "${car['Car price']} Per day",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Description",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    car['Car description'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Location",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded),
                      Text(
                        car['Car location'],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Owner",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    owner['First name'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            userId: car['Car owner'],
                            carId: car['id'],
                          ),
                        ),
                      );
                    },
                    child: Text('ارسل رساله الي صاحب الي صاحب السيارة'),
                  ),
                ],
              ),
            ),
    );
  }
}
