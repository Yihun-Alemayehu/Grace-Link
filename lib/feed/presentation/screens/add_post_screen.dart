import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grace_link/auth/models/user_model.dart';
import 'package:grace_link/auth/presentation/screens/auth_screen.dart';
import 'package:grace_link/auth/repos/auth_repo.dart';
import 'package:grace_link/feed/presentation/bloc/feed_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final AuthRepo _authRepo = AuthRepo();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();

  Future<void> pickImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    _image = File(image!.path);
    setState(() {});
  }

  MyUser? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    _user = await _authRepo.getCurrentMyUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    User? user = _authRepo.getCurrentUser();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create a post ${_user?.accountType}'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            size: 32,
          ),
        ),
        elevation: 3,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocConsumer<FeedBloc, FeedState>(
          listener: (context, state) {
            if (state is ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            } else if (state is PostAddedstate) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                  (route) => false);
            }
          },
          builder: (context, state) {
            if (state is FeedLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.inkDrop(
                        color: Colors.black, size: 50),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 20.h, right: 20.w, left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: user!.photoURL == null
                              ? const AssetImage('assets/avatar.png')
                                  as ImageProvider<Object>?
                              : NetworkImage(user.photoURL!),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.displayName!),
                            const Text(
                              'public',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                        'What\'s on your mind, ${user.displayName!.split(' ')[0]} ?'),
                    SizedBox(
                      height: 20.h,
                    ),
                    _image == null
                        ? GestureDetector(
                            onTap: () {
                              pickImage();
                            },
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.28,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 80.0.w, vertical: 80.0.h),
                                  child: SizedBox(
                                    child: Image.asset('assets/add-image.png'),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.28.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 60.h,
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'type here...',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: Size(305.w, 48.h),
                            backgroundColor: Colors.black),
                        onPressed: () {
                          context.read<FeedBloc>().add(AddPostEvent(
                              text: _textController.text,
                              image: _image!,
                              accountType: _user?.accountType ?? 'user'));
                        },
                        child: Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
