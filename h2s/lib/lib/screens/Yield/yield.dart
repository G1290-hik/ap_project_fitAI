import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:h2s/models/app_localization.dart';
import 'package:h2s/screens/Yield/result.dart';

class Yield extends StatefulWidget {
  @override
  _YieldState createState() => _YieldState();
}

class _YieldState extends State<Yield> {
  @override
  Widget build(BuildContext context) {
    return FirebaseRealtimeDemoScreen();
  }
}

class FirebaseRealtimeDemoScreen extends StatefulWidget {
  @override
  _FirebaseRealtimeDemoScreenState createState() =>
      _FirebaseRealtimeDemoScreenState();
}

class _FirebaseRealtimeDemoScreenState
    extends State<FirebaseRealtimeDemoScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  User? user;
  bool _validate = false;
  bool isLoading = false;

  double? ahumid, atemp, rainfall, sph, shumid;

  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    readData();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Crop Prediction')),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(
                  AppLocalizations.of(context).translate("Let's Predict Your Crop"),
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SizedBox(height: 5.0),
              Form(
                key: _key,
                autovalidateMode:
                _validate ? AutovalidateMode.always : AutovalidateMode.disabled,
                child: FormUI(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    return Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('Air Humidity'),
          ),
          maxLength: 32,
          validator: validateNumber,
          onSaved: (String? val) {
            ahumid = double.parse(val!);
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('Air Temperature'),
          ),
          keyboardType: TextInputType.number,
          maxLength: 10,
          validator: validateNumber,
          onSaved: (String? val) {
            atemp = double.parse(val!);
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('Rainfall'),
          ),
          keyboardType: TextInputType.number,
          maxLength: 32,
          validator: validateNumber,
          onSaved: (String? val) {
            rainfall = double.parse(val!);
          },
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('Soil Humidity'),
          ),
          maxLength: 32,
          validator: validateNumber,
          onSaved: (String? val) {
            shumid = double.parse(val!);
          },
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate('Soil pH'),
          ),
          maxLength: 15,
          validator: validateNumber,
          onSaved: (String? val) {
            sph = double.parse(val!);
          },
        ),
        SizedBox(height: 15.0),
        isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _sendToServer,
          child: Text(AppLocalizations.of(context).translate('Send')),
        ),
      ],
    );
  }

  Future<void> createData() async {
    try {
      await databaseReference.child("Realtime").update({
        'Air Humidity': ahumid,
        'Air Temp': atemp,
        'Rainfall': rainfall,
        'Soil Humidity': shumid,
        'Soil pH': sph,
      });
    } catch (e) {
      print("Error creating data: $e");
      // Handle error (show a message to the user)
    }
  }

  void readData() {
    databaseReference.child("Realtime").once().then((DataSnapshot snapshot) {
      print('Data: ${snapshot.value}');
    } as FutureOr Function(DatabaseEvent value));
  }

  String? validateNumber(String? value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "This field is required";
    } else if (!regExp.hasMatch(value)) {
      return "Only numerical values are allowed";
    }
    return null;
  }

  Future<void> _sendToServer() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await createData();
      setState(() {
        isLoading = false;
      });
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Result()),
      );
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
