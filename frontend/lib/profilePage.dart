
import 'dart:io';

import 'package:GTEvents/component/imageSelector.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("profile"),),
      // body: ListView(
      //   padding: const EdgeInsets.symmetric(
      //     vertical: 80,
      //     horizontal: 20,
      //   ),
      //   children: [ProfilePage(),],
      // ),
      body: ProfileImage(),
    );
  }
}

class ProfileImage extends StatefulWidget {
  // final String username;
  // const ProfileImage({super.key, required this.username});
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImage();
}

class _ProfileImage extends State<ProfileImage> {
  File? _image;
  ImageSelector imageSelector = ImageSelector();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 64,
              foregroundImage: _image != null ? FileImage(_image!) : null,
            ),
          ),
        ),
        const SizedBox(height: 16,),
        TextButton(
            onPressed: () async {
              final imgs = await imageSelector.pickImage();
              if (imgs.isNotEmpty) {
                final croppedImg = await imageSelector.cropImage(
                  file: imgs.first,
                  cropStyle: CropStyle.circle,
                );
                if (croppedImg != null) {
                  setState(() {
                    _image = File(croppedImg.path);
                  });
                }
              }
            },
            child: const Text("Select image"),
        ),
      ],
    );
  }
}