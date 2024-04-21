import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:grace_link/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:grace_link/shared/route/routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is EmailVerificationSentState) {
              Get.toNamed(RouteClass.confirmEmail);
            } else if (state is ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error has occured ${state.errorMessage}'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: Colors.black, size: 50),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mail,
                  size: 60.sp,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Verify your email',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'We would like to send email verification link on your email to verify your email address. Would you like to receive verification link on your email ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: Size(305.w, 48.h),
                      backgroundColor: Colors.black),
                  onPressed: () {
                    context.read<AuthBloc>().add(VerifyEmailEvent());
                  },
                  child: Text(
                    'Send Verification Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            );
          },
        ),
      )),
    );
  }
}
