import 'package:car_rent_app/Core/car.dart';
import 'package:car_rent_app/Shared/car_card.dart';
import 'package:car_rent_app/Shared/custom_textfeild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> cars = [];
  List<bool> favorites = [];

  Future<void> getCars() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('cars')
        .where(
          'Car owner',
          isNotEqualTo: FirebaseAuth.instance.currentUser?.uid,
        )
        .get();

    if (!mounted) return;

    setState(() {
      cars = data.docs.map((doc) {
        return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();

      favorites = List.generate(cars.length, (index) => false);
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
            icon: const CircleAvatar(child: Icon(Icons.person)),
          ),
          title: CustomTextfeild(
            controller: searchController,
            lable: 'ابحث عن السيارة اللتي تريدها',
            icon: Icons.search,
          ),
        ),
        body: GridView.builder(
          itemCount: cars.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              carId: cars[index]['id'],
            );

            return CarCard(
              car: car,
              ownername: getOwnerName(uid: car.owner),
              isFavorit: favorites[index],
              carId: car.carId,
            );
          },
        ),
      ),
    );
  }
}
