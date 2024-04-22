import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:grace_link/auth/presentation/screens/auth_screen.dart';
import 'package:grace_link/feed/presentation/screens/main_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CompleteRegistrationScreen extends StatefulWidget {
  const CompleteRegistrationScreen({super.key});

  @override
  State<CompleteRegistrationScreen> createState() =>
      _CompleteRegistrationScreenState();
}

class _CompleteRegistrationScreenState
    extends State<CompleteRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _firstValue = '';

  final List<String> _genderOptions = ['Male', 'Female'];

  Future<void> pickImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    _image = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is ProfileCompletedState) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                    (route) => false);
              } else if (state is ErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage),
                ));
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete Registration',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Enter your details below',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60.r,
                        backgroundImage: _image == null
                            ? const AssetImage('assets/add-user.png')
                                as ImageProvider<Object>?
                            : FileImage(_image!),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 20.h, right: 20.w, left: 20.w),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              label: Text(
                                'Username',
                                style: TextStyle(color: Colors.grey),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (firstName) => firstName!.length < 3
                                ? 'Username should be at least two characters'
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(height: 20.h),
                          TextFormField(
                              controller: _bioController,
                              decoration: const InputDecoration(
                                label: Text(
                                  'Bio',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                prefixIcon:
                                    Icon(Icons.post_add, color: Colors.grey),
                              ),
                              validator: (bio) => bio!.length < 2
                                  ? "bio should be at least two characters"
                                  : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction),
                          SizedBox(height: 20.h),
                          FormBuilderDropdown<String>(
                            name: 'Gender',
                            decoration: InputDecoration(
                              hintText: 'Gender',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                            ),
                            items: _genderOptions
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _firstValue = value;
                                }
                              });
                            },
                            valueTransformer: (value) => value.toString(),
                            validator: (value) => value == null
                                ? 'Please select your Gender'
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(height: 30.h),
                          TextButton(
                            style: TextButton.styleFrom(
                                fixedSize: Size(305.w, 48.h),
                                backgroundColor: Colors.black),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      CompleteProfileEvent(
                                          username: _usernameController.text,
                                          bio: _bioController.text,
                                          gender: _firstValue,
                                          profileImage: _image!),
                                    );
                              }
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextButton(
                            style: TextButton.styleFrom(
                              fixedSize: Size(305.w, 48.h),
                              // backgroundColor: Colors.black
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AuthScreen(),
                                  ),
                                  (route) => false);
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 21.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ));
  }
}
