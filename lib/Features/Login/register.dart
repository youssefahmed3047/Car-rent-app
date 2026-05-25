// ignore_for_file: use_build_context_synchronously

import 'package:car_rent_app/Features/Home/home_page.dart';
import 'package:car_rent_app/Shared/custom_textfeild.dart';
import 'package:car_rent_app/Shared/login_options_package.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Register extends StatefulWidget {
  final VoidCallback navigation;

  const Register({super.key, required this.navigation});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
                      'تسجيل دخول',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Text(
                  'تسجيل حساب',
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
            height: 480.h,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180.w,
                        height: 60.h,
                        child: CustomTextfeild(
                          controller: firstNameController,
                          lable: 'الاسم الاول',
                          icon: Icons.face,
                        ),
                      ),
                      SizedBox(
                        width: 180.w,
                        height: 60.h,
                        child: CustomTextfeild(
                          controller: lastNameController,
                          lable: 'الاسم الاخير',
                          icon: Icons.face,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  CustomTextfeild(
                    controller: emailController,
                    lable: 'البريد الالكتروني',
                    icon: Icons.email,
                  ),

                  SizedBox(height: 10.h),

                  CustomTextfeild(
                    controller: phoneNumberController,
                    lable: 'رقم الهاتف',
                    icon: Icons.phone,
                  ),

                  SizedBox(height: 10.h),

                  CustomTextfeild(
                    controller: passwordController,
                    lable: 'كلمة السر',
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
                                .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .set({
                                  'First name': firstNameController.text,
                                  'Last name': lastNameController.text,
                                  'Email': emailController.text,
                                  'Phone number': phoneNumberController.text,
                                });
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
                              color: colors.onPrimary,
                            ),
                          )
                        : Text('تسجيل حساب'),
                  ),

                  Divider(color: colors.primary.withValues(alpha: 0.5)),

                  Text('او سجل دخولك باستخدام'),

                  SizedBox(height: 10.h),

                  LoginOptionsPackage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
