// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:car_rent_app/Core/cloudinary_service.dart';
import 'package:car_rent_app/Shared/custom_textfeild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  bool isLoading = false;

  TextEditingController carController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  List<XFile> images = [];

  Future<void> pickFromCamera() async {
    if (images.length >= 3) return;

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        images.add(image);
      });
    }
  }

  Future<void> pickFromGallery() async {
    final List<XFile> selectedImages = await picker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      setState(() {
        int remaining = 3 - images.length;
        images.addAll(selectedImages.take(remaining));
      });
    }
  }

  void showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 180.h,
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Text(
                'اختر مصدر الصور',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickFromCamera();
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          child: Icon(Icons.camera_alt, size: 30.sp),
                        ),
                        SizedBox(height: 8.h),
                        Text('الكاميرا'),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickFromGallery();
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          child: Icon(Icons.photo_library, size: 30.sp),
                        ),
                        SizedBox(height: 8.h),
                        Text('المعرض'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔥 FIXED IMAGE VIEW (NO FILE)
  Widget imageContainer(XFile image) {
    return FutureBuilder<Uint8List>(
      future: image.readAsBytes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 250.h,
            margin: EdgeInsets.only(bottom: 10.h),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          width: double.infinity,
          height: 250.h,
          margin: EdgeInsets.only(bottom: 10.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.memory(snapshot.data!, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget addImageContainer() {
    return GestureDetector(
      onTap: showPicker,
      child: Container(
        width: double.infinity,
        height: 250.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 40.sp),
              Text(
                'اضف صور لسيارتك',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (images.isEmpty) return;

    setState(() => isLoading = true);

    try {
      CloudinaryService cloudinaryService = CloudinaryService();

      final urls = await cloudinaryService.uploadImages(images);

      FirebaseFirestore.instance.collection('cars').doc().set({
        'Car name': carController.text,
        'Car price': double.parse(priceController.text),
        'Car description': descriptionController.text,
        'Car location': locationController.text,
        'Car owner': FirebaseAuth.instance.currentUser!.uid,
        'Car images': urls,
      });
    } catch (e) {
      print("Error: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text('املأ البيانات التالية لاضافة سيارتك'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              CustomTextfeild(
                controller: carController,
                lable: 'ادخل اسم سيارتك',
                icon: Icons.car_rental_outlined,
              ),

              SizedBox(height: 10.h),

              CustomTextfeild(
                controller: priceController,
                lable: 'ادخل سعر الايجار المطلوب',
                icon: Icons.attach_money,
              ),

              SizedBox(height: 10.h),

              CustomTextfeild(
                controller: locationController,
                lable: 'العنوان',
                icon: Icons.location_on,
              ),

              SizedBox(height: 10.h),

              CustomTextfeild(
                controller: descriptionController,
                lable: 'وصف السيارة',
                icon: Icons.description,
                isTall: true,
              ),

              SizedBox(height: 10.h),

              ...images.map((image) => imageContainer(image)),

              if (images.length < 3) addImageContainer(),

              SizedBox(height: 10.h),

              ElevatedButton(
                onPressed: isLoading ? null : submit,
                child: isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        'اضف السيارة',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
