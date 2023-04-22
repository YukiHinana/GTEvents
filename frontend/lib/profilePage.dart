
import 'dart:io';

import 'package:GTEvents/component/imageSelector.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("profile"),
        actions: <Widget>[
          IconButton(
              onPressed: () => context.pushReplacement('/events'),
              icon: const Icon(Icons.home))
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: ProfileImage(),
      ),
    );
  }
}

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImage();
}

class _ProfileImage extends State<ProfileImage> {
  File? _image;
  ImageSelector imageSelector = ImageSelector();

  Future<void> setAvatarRequest(File img, String? token) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(img.path),
    });
    Dio dio = new Dio();
    var response = await dio.post(
        '${Config.baseURL}/account/avatar',
        data: formData,
        options: Options(headers: {
          "Authorization": token??"",
        }),
    );
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    String croppedImgPath = "";

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
        const SizedBox(height: 5,),
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
                    setAvatarRequest(File(croppedImg.path), "8d673738-d084-4e23-aa87-203462064662");
                    croppedImgPath = croppedImg.path;
                  });
                }
              }
            },
            child: const Text("Change Avatar"),
        ),
      ],
    );
  }
}