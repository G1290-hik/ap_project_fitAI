import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:h2s/screens/smartConnect/add_crop_ctrl.dart';

class AddCrop extends StatefulWidget {
  @override
  _AddCropState createState() => _AddCropState();
}

class _AddCropState extends State<AddCrop> {
  File? imageFile;
  final addCropCtrl = Get.put(AddCropCtrl());
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future<void> _getImage(bool fromCamera) async {
      final pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else {
        Get.snackbar('Error', 'No image selected.');
      }
    }

    Widget _addPhoto() {
      return Column(
        children: <Widget>[
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            height: 200,
            width: 200,
            child: imageFile == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Add Photo"),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () => _getImage(true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_library),
                      onPressed: () => _getImage(false),
                    ),
                  ],
                ),
              ],
            )
                : Image.file(
              imageFile!,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () async {
                if (imageFile != null) {
                  await addCropCtrl.addCrop(imageFile!);
                  Navigator.pop(context);
                } else {
                  Get.snackbar('Error', 'Please select an image.');
                }
              },
              shape: const StadiumBorder(),
              child: const Text(
                "Upload",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              padding: const EdgeInsets.all(5),
              shrinkWrap: true,
              children: [
                const SizedBox(height: 10),
                _addPhoto(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    onChanged: (value) => addCropCtrl.cropModel.cropName = value,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(),
                      labelText: "Crop Name",
                      hintText: "Tomato, Onion, etc.",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    onChanged: (value) => addCropCtrl.cropModel.msp = value,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(),
                        labelText: "Minimum Support Price",
                        hintText: "e.g., Rs xxx/tonne"),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    onChanged: (value) =>
                    addCropCtrl.cropModel.cropQuantity = value,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(),
                        labelText: "Quantity",
                        hintText: "Include the organic status and region"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    onChanged: (value) =>
                    addCropCtrl.cropModel.cropDescription = value,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(),
                        labelText: "Crop Description",
                        hintText: "Include the organic status and region"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
