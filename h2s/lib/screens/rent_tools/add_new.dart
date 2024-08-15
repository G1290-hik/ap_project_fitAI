import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'add_rent_tools_ctrl.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  XFile? imageFile;
  String dropdownValue = "Tractors";
  final logger = Logger();
  final addRentToolsCtrl = Get.put(AddRentToolsCtrl());

  Future<void> _getImage(bool fromCamera) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    if (fromCamera) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        addRentToolsCtrl.rentToolsModel.toolImage = pickedFile!.path;
      });
    }
  }

  Widget _addPhoto() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          height: 200,
          width: 200,
          child: imageFile == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("Add Photo"),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      _getImage(true);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_library),
                    onPressed: () {
                      _getImage(false);
                    },
                  ),
                ],
              ),
            ],
          )
              : Image.file(
            File(imageFile!.path),
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await addRentToolsCtrl.addRentTools(imageFile as File);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
              ),
              child: Text(
                "Done",
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        children: [
          SizedBox(height: 10),
          _addPhoto(),
          SizedBox(height: 10),
          TextFormField(
            onChanged: (value) {
              addRentToolsCtrl.rentToolsModel.toolName = value;
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(),
              labelText: "Name",
              hintText: "Name",
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            onChanged: (value) {
              addRentToolsCtrl.rentToolsModel.toolPricePerDay = value;
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(),
              labelText: "Cost per Day",
              hintText: "eg : Rs xxx/day",
            ),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(),
              labelText: "Category",
            ),
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                addRentToolsCtrl.rentToolsModel.toolType = newValue;
              });
            },
            items: <String>['Tractors', 'Harvestors', 'Pesticides', 'Others']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          TextFormField(
            onChanged: (value) {
              addRentToolsCtrl.rentToolsModel.toolDescription = value;
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(),
              labelText: "Description",
              hintText: "Description",
            ),
          ),
        ],
      ),
    );
  }
}
