import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:grace_link/auth/presentation/screens/complete_registration_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ConfirmEmailScreen extends StatelessWidget {
  const ConfirmEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is EmailVerificationSentState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verification email sent successfully !'),
                  ),
                );
              } else if (state is ErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error has occured ${state.errorMessage}'),
                  ),
                );
              } else if (state is EmailVerifiedState) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompleteRegistrationScreen(),
                    ),
                    (route) => false);
              } else if (state is EmailNotVerifiedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Your Email is not verified. Please verify your email and try again!'),
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
                  SizedBox(
                    height: 30.h,
                  ),
                  Icon(
                    Icons.mark_email_read_rounded,
                    size: 60.sp,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Verify your email address',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'We have just send email verification link on your email. Please check email and click on that link to verify your email address.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'If not auto redirected after verification, click on the Continue button.',
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
                      context.read<AuthBloc>().add(
                            ReloadUserEvent(),
                          );
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: Size(305.w, 48.h),
                        backgroundColor: Colors.black),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            VerifyEmailEvent(),
                          );
                    },
                    child: Text(
                      'Resent Verification email',
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
        ),
      ),
    );
  }
}
