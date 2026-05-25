// ignore_for_file: use_build_context_synchronously

import 'package:car_rent_app/Features/Home/home_page.dart';
import 'package:car_rent_app/Shared/custom_textfeild.dart';
import 'package:car_rent_app/Shared/login_options_package.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  final VoidCallback navigation;
  const Login({super.key, required this.navigation});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 400.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.navigation,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'تسجيل حساب',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 35.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 400.w,
            height: 372.h,
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
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                children: [
                  CustomTextfeild(
                    controller: emailController,
                    lable: 'ادخل البريد الالكتروني',
                    icon: Icons.email,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextfeild(
                    controller: passwordController,
                    lable: 'ادخل كلمة السر',
                    icon: Icons.password,
                    isHiden: true,
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : Text('تسجيل الدخول'),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'هل نسيت كلمة السر ؟',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  Text('او سجل دخولك باستخدام'),
                  SizedBox(height: 10.h),
                  LoginOptionsPackage(),
                  SizedBox(height: 25.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
