import 'package:car_rent_app/Features/Login/login.dart';
import 'package:car_rent_app/Features/Login/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background car.png'),
            ),
          ),
          child: PageView(
            controller: pageController,
            children: [
              Login(
                navigation: () {
                  pageController.animateToPage(
                    1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastEaseInToSlowEaseOut,
                  );
                },
              ),
              Register(
                navigation: () {
                  pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastEaseInToSlowEaseOut,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
