import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? file;
  String disease = "";

  @override
  void initState() {
    Tflite.loadModel(
      model: "assets/data/model2.tflite",
      labels: "assets/data/labels.txt",
      // useGpuDelegate: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          file != null
              ? SizedBox(
                  height: 200,
                  child: Image.file(file!),
                )
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          Center(
              child: MaterialButton(
            onPressed: () async {
              var img =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (img != null) {
                file = File(img!.path);
                var recognition = await Tflite.runModelOnImage(
                    path: file!.path, imageMean: 0.0,   // defaults to 117.0
                    imageStd: 255.0,  // defaults to 1.0
                    numResults: 2,    // defaults to 5
                    threshold: 0.2,   // defaults to 0.1
                    asynch: true );
                setState(() {
                  if (recognition != null) {
                    disease = recognition.toString();
                  }
                });
              }
            },
            child: Text("Select Image"),
          )),
          Center(
            child: Text("Detection: ${disease}"),
          )
        ],
      ),
    );
  }
}
