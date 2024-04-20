import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:grace_link/feed/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: FormBuilder(
              key: _formKey,
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is SignedUpState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
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
                        'Welcome back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        'Create an account to continue',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
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
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
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
                        height: 10.h,
                      ),
                      Text(
                        'Full name',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        height: 68.h,
                        width: 305.w,
                        child: FormBuilderTextField(
                          controller: _nameController,
                          name: 'name',
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            hintText: 'Full name',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: const Icon(Icons.person),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 20.w,
                            ),
                          ),
                          validator: (name) {
                            List<String> nameParts = name!.split(' ');
                            if (nameParts.length < 2) {
                              return 'Please enter a full name';
                            } else if (nameParts[1].isEmpty) {
                              return 'Please enter a valid full name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        height: 68.h,
                        width: 305.w,
                        child: FormBuilderTextField(
                          controller: _passwordController,
                          name: 'password',
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            hintText: 'password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: const Icon(Icons.lock_open_outlined),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 20.w,
                            ),
                          ),
                          validator: (name) => name!.length < 6
                              ? 'Password must be at least 6 characters long'
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Confirm password',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(
                        height: 68.h,
                        width: 305.w,
                        child: FormBuilderTextField(
                            controller: _confirmPasswordController,
                            name: 'Confirm password',
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              hintText: 'confirm password',
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: const Icon(Icons.lock),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 20.w,
                              ),
                            ),
                            validator: (confirm) {
                              if (confirm!.length < 6) {
                                return 'Password must be at least 6 characters long';
                              } else if (confirm != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            }),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: Size(305.w, 48.h),
                            backgroundColor: Colors.black),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            context.read<AuthBloc>().add(SignUpEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                                fullName: _nameController.text));
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account ?',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ))
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }
}
