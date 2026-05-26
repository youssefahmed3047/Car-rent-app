import 'package:car_rent_app/Core/app_theme.dart';
import 'package:car_rent_app/Core/car_id_provider.dart';
import 'package:car_rent_app/Core/firebase_options.dart';
import 'package:car_rent_app/Core/hive_service.dart';
import 'package:car_rent_app/Features/Home/home_page.dart';
import 'package:car_rent_app/Features/Login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox(HiveService.favoritesBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarIDProvider(),
      child: ScreenUtilInit(
        designSize: Size(500, 1000),
        builder: (context, child) => MaterialApp(
          title: 'Car rent app',
          theme: AppTheme.darkTheme,
          home: FirebaseAuth.instance.currentUser == null
              ? LoginPage()
              : HomePage(),
        ),
      ),
    );
  }
}
