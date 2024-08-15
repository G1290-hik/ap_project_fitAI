import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2s/models/rent_tools_model.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRentToolsCtrl extends GetxController {
  RentToolsModel rentToolsModel = RentToolsModel();
  String picDownloadUrl = '';
  var logger = Logger(printer: PrettyPrinter());
  final isLoading = false.obs;
  User? firebaseUser;
  String ownerContactInfo = "";

  Future<String?> postImage(File imageFile) async {
    logger.d('Inside postImage');

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
    FirebaseStorage.instance.ref().child('rentTools/$fileName');

    UploadTask uploadTask = storageReference.putFile(imageFile);
    logger.d('Uploading image...');

    try {
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      logger.d("Image uploaded, URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      logger.e("Failed to upload image: $e");
      return null;
    }
  }

  Future<void> getCurrentUser() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      var contact = firebaseUser!.phoneNumber ?? '';
      rentToolsModel.ownerContactInfo = contact;
      logger.d("User contact info: $contact");
    } else {
      logger.e("No user logged in");
    }
  }

  Future<void> addRentTools(File imageFile) async {
    Get.dialog(
      Material(
        child: Padding(
          padding: const EdgeInsets.only(top: 300.0),
          child: Center(
            child: Column(
              children: [
                Text("Uploading... Please wait"),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );

    String? imageUrl = await postImage(imageFile);
    if (imageUrl != null) {
      rentToolsModel.toolImage = imageUrl;

      await getCurrentUser();

      try {
        await FirebaseFirestore.instance
            .collection("rentTools")
            .add(rentToolsModel.toJson());
        logger.d("Tool added successfully");
      } catch (e) {
        logger.e("Failed to add tool: $e");
      } finally {
        Get.back();
      }
    } else {
      logger.e("Failed to upload image");
      Get.back();
    }
  }
}
