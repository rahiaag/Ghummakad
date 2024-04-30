import "dart:io";
import "dart:typed_data";

import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import 'package:ghumakkad_2/services/firestore_methods.dart';
import "package:ghumakkad_2/utils/showSnackBar.dart";
import "package:image_picker/image_picker.dart";
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import "package:random_string/random_string.dart";

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName = "", title = "", desc = "";

  Uint8List? selectedimage;
  bool _isLoading = false;
  FireStoreMethods fireStoreMethods = FireStoreMethods();

  pickImage(ImageSource src) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: src);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print("No image selected");
  }

  uploadBlog() async {
    if (selectedimage != null) {
      setState(() {
        _isLoading = true;
      });

      String res = await FireStoreMethods().uploadPost(
         desc, selectedimage!, title, authorName);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, "Blog Posted");
        clearImage();
        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });
        print(res);
        showSnackBar(context, res);
        Navigator.pop(context);
      }
      

      // Reference firebaseStorageRef = FirebaseStorage.instance
      //     .ref()
      //     .child("blogImages")
      //     .child("${randomAlphaNumeric(9)}.jpg");

      // final UploadTask task = firebaseStorageRef.putData(selectedimage!);

      // var downloadUrl = await (await task.whenComplete(() => 'File Uploaded'))
      //     .ref
      //     .getDownloadURL();
      // print("this is url $downloadUrl");

      // Map<String, String> blogMap = {
      //   "imgUrl": downloadUrl,
      //   "authorName": authorName,
      //   "title": title,
      //   "desc": desc,
      // };
      // fireStoreMethods.addData(blogMap).then((result) {
      //   Navigator.pop(context);
      // });
    } else {}
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Blog"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    selectedimage = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    selectedimage = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      selectedimage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Ghumakkad",
                style: TextStyle(fontSize: 22),
              ),
              Text(" Blog", style: TextStyle(fontSize: 22, color: Colors.blue))
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
              onTap: uploadBlog,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.file_upload)),
            )
          ]),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : SingleChildScrollView(
            child: Container(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    selectedimage != null
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(selectedimage!),
                                  fit: BoxFit.contain,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                            width: MediaQuery.of(context).size.width,
                            child: IconButton(
                              onPressed: () => _selectImage(context),
                              icon: const Icon(Icons.add_a_photo),
                              color: Colors.black45,
                            ),
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            decoration: const InputDecoration(hintText: "Author Name"),
                            onChanged: (val) {
                              authorName = val;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(hintText: "Title"),
                            onChanged: (val) {
                              title = val;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(hintText: "Desc"),
                            onChanged: (val) {
                              desc = val;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
