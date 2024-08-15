import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:h2s/models/crop_model.dart';

class DisplayCropCtrl extends GetxController {
  CropModel cropModel=CropModel();
  final isLoading=false.obs;
  cropStream(){
    FirebaseFirestore.instance.collection('crop').get();
  }
}
