import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final FeedBloc _feedBloc = FeedBloc();
  final AuthRepo _authRepo = AuthRepo();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();

  Future<void> pickImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    _image = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    User? user = _authRepo.getCurrentUser();
    return Scaffold(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is FeedLoading) {
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: Colors.black, size: 50),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
                child: Column(
                  children: [
                    const Text('Upload picture'),
                    const SizedBox(
                      height: 40,
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
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.camera_alt_rounded),
                              ),
                            ),
                          )
                        : Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 150,
                              height: 150,
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
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
                        context.read<FeedBloc>().add(AddPostEvent(
                            text: _textController.text, image: _image!));
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21.sp,
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
