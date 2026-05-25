import 'package:car_rent_app/Shared/other_login_option.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginOptionsPackage extends StatelessWidget {
  const LoginOptionsPackage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OtherLoginOption(
          backgroundColor: Colors.white,
          iconColor: Colors.red,
          icon: FontAwesomeIcons.google,
          action: () {},
        ),
        OtherLoginOption(
          backgroundColor: Colors.blue,
          iconColor: Colors.white,
          icon: FontAwesomeIcons.facebook,
          action: () {},
        ),
        OtherLoginOption(
          backgroundColor: Colors.black,
          iconColor: Colors.white,
          icon: FontAwesomeIcons.apple,
          action: () {},
        ),
      ],
    );
  }
}
