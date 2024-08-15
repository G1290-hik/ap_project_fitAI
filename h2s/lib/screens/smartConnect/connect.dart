import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h2s/models/crop_model.dart';
import 'package:h2s/screens/smartConnect/addCrop.dart';
import 'package:h2s/screens/smartConnect/crop_template.dart';

class Crop {
  final String imageUrl;
  final String desc;
  final String msp;

  Crop({required this.imageUrl, required this.desc, required this.msp});
}

class ConnectScreen extends StatefulWidget {
  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Connect"),
      ),
      body: StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance.collection('crop').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot cropSnapshot = snapshot.data.documents[index];
                CropModel cropModel = CropModel.fromJson(cropSnapshot.data as Map<String, dynamic>);
                return CropTemplate(cropModel: cropModel);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCrop()),
          );
        },
      ),
    );
  }
}
