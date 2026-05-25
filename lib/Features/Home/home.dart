import 'package:car_rent_app/Core/car.dart';
import 'package:car_rent_app/Shared/custom_textfeild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> cars = [];

  Future<void> getCars() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('cars')
        .where(
          'Car owner',
          isNotEqualTo: FirebaseAuth.instance.currentUser?.uid,
        )
        .get();

    setState(() {
      cars = data.docs.map((doc) {
        return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    });
  }

  Future<String> getOwnerName({required String uid}) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final user = snapshot.data() as Map<String, dynamic>;
    return user['First name'];
  }

  @override
  void initState() {
    super.initState();
    getCars();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: CircleAvatar(child: Icon(Icons.person)),
          ),
          title: CustomTextfeild(
            controller: searchController,
            lable: 'ابحث عن السيارة اللتي تريدها',
            icon: Icons.search,
          ),
        ),
        body: GridView.builder(
          itemCount: cars.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.96,
          ),
          itemBuilder: (context, index) {
            Car car = Car(
              name: cars[index]['Car name'],
              price: cars[index]['Car price'],
              location: cars[index]['Car location'],
              owner: cars[index]['Car owner'],
              description: cars[index]['Car description'],
              images: cars[index]['Car images'],
            );
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.9),
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
                          image: NetworkImage(car.images[0]),
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
                            car.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${car.price} EGP Per Day',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15.sp,
                            ),
                          ),
                          FutureBuilder<String>(
                            future: getOwnerName(uid: car.owner),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 15.sp,
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Text(
                                  'Error',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                                car.location,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 15.sp,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
