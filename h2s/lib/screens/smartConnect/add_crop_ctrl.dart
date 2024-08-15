import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2s/models/crop_model.dart';
import 'package:logger/logger.dart';

class AddCropCtrl extends GetxController {
  CropModel cropModel = CropModel();
  String picDownloadUrl = '';
  var logger = Logger(printer: PrettyPrinter());
  late String contact;

  Future<dynamic> postImage(File imageFile) async {
    logger.d('inside postImage');
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
    FirebaseStorage.instance.ref().child('crop/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    logger.d('Uploading image...');

    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() => {});
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    logger.d('Download URL: $downloadUrl');
    return downloadUrl;
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      contact = user.phoneNumber ?? '';
      cropModel.ownerContactInfo = contact;
    } else {
      logger.e('No current user found');
    }
  }

  Future<void> addCrop(File imageFile) async {
    Get.dialog(
      Material(
        child: Padding(
          padding: const EdgeInsets.only(top: 300.0),
          child: Center(
            child: Column(
              children: const [
                Text("Uploading... Please wait"),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      String imageUrl = await postImage(imageFile);
      cropModel.cropImage = imageUrl;
      logger.d("CropImage URL: ${cropModel.cropImage}");

      await getCurrentUser();

      await FirebaseFirestore.instance
          .collection("crop")
          .add(cropModel.toJson());

      Get.back();
    } catch (e) {
      logger.e('Error adding crop: $e');
      Get.back();
      Get.snackbar('Error', 'Failed to add crop. Please try again.');
    }
  }
}
