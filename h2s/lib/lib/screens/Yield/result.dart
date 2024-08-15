import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  double? ahumid, atemp, rainfall, sph, shumid;
  String? crop;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Result"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : isError
              ? Text("An error occurred while fetching data")
              : Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                crop != null
                    ? Center(
                  child: Text(
                    "Predicted Crop: $crop",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
                    : Text("No crop data available"),
                SizedBox(height: 20),
                crop != null
                    ? Image.asset(
                  "assets/${crop!.toLowerCase()}.jpg",
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void readData() async {
    try {
      // Fetch Realtime data
      DatabaseEvent realtimeSnapshot = await databaseReference.child("Realtime").once();
      Map<dynamic, dynamic>? realtimeValues = realtimeSnapshot.snapshot as Map<dynamic, dynamic>?;

      setState(() {
        ahumid = realtimeValues?['Air Humidity'] ?? 0.0;
        atemp = realtimeValues?['Air Temp'] ?? 0.0;
        rainfall = realtimeValues?['Rainfall'] ?? 0.0;
        shumid = realtimeValues?['Soil Humidity'] ?? 0.0;
        sph = realtimeValues?['Soil pH'] ?? 0.0;
      });

      // Fetch Crop Prediction data
      DatabaseEvent cropSnapshot = await databaseReference.child("croppredicted").once();
      Map<dynamic, dynamic>? cropValues = cropSnapshot.snapshot as Map<dynamic, dynamic>?;

      setState(() {
        crop = cropValues?['crop'] ?? "Unknown";
        isLoading = false;
      });

      print(crop);
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      print("Error: $e");
    }
  }
}
