import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextfeild extends StatefulWidget {
  final TextEditingController controller;
  final String lable;
  final IconData icon;
  final bool isHiden;
  final bool isTall;
  final VoidCallback? action;

  const CustomTextfeild({
    super.key,
    required this.controller,
    required this.lable,
    required this.icon,
    this.isHiden = false,
    this.isTall = false,
    this.action,
  });

  @override
  State<CustomTextfeild> createState() => _CustomTextfeildState();
}

class _CustomTextfeildState extends State<CustomTextfeild> {
  bool obscureText = true;
  IconData obscureIcon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      maxLines: widget.isTall ? 5 : 1,
      controller: widget.controller,
      obscureText: widget.isHiden ? obscureText : false,
      cursorColor: colors.primary,
      style: TextStyle(color: colors.onSurface, fontSize: 16.sp),
      decoration: InputDecoration(
        labelText: widget.lable,
        labelStyle: TextStyle(color: Colors.white70, fontSize: 15.sp),
        prefixIcon: Icon(widget.icon, color: colors.primary),
        suffixIcon: widget.isHiden
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                    obscureIcon = obscureText
                        ? Icons.visibility_off
                        : Icons.visibility;
                  });
                },
                icon: Icon(obscureIcon, color: colors.primary),
              )
            : widget.action != null
            ? IconButton(onPressed: widget.action, icon: Icon(Icons.send))
            : null,
        filled: true,
        fillColor: colors.primary.withValues(alpha: 0.08),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: colors.primary.withValues(alpha: 0.25),
            width: 1.2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: colors.primary, width: 2.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: Colors.red, width: 1.5.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: Colors.red, width: 2.w),
        ),
      ),
    );
  }
}
