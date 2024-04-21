import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.adaptive.arrow_back),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: FormBuilder(
          key: _formKey,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is ForgotPasswordState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Password reset email is successfully sent !'),
                  ),
                );
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forget Password',
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Enter your email address to reset your password',
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(
                    height: 68.h,
                    width: 305.w,
                    child: FormBuilderTextField(
                      controller: _emailController,
                      name: 'email',
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: const Icon(Icons.email_rounded),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 20.w,
                        ),
                      ),
                      validator: validateEmail,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: Size(305.w, 48.h),
                        backgroundColor: Colors.black),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        context.read<AuthBloc>().add(
                              ForgotPasswordEvent(
                                email: _emailController.text,
                              ),
                            );
                      }
                    },
                    child: Text(
                      'Forget Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.sp,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )),
    );
  }
}
