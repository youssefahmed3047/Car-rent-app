import 'package:car_rent_app/Features/Home/add_car.dart';
import 'package:car_rent_app/Features/Home/home.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: const [
            Home(),
            Center(child: Text("Favorites")),
            AddCar(),
            Center(child: Text("Chats")),
            Center(child: Text("Profile")),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
            pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastEaseInToSlowEaseOut,
            );
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسيه'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'المفضلات',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'اضف سيارتك'),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'المحادثات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.face),
              label: 'الصفحة الشخصيه',
            ),
          ],
        ),
      ),
    );
  }
}
