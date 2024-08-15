import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:h2s/main.dart';
import 'package:h2s/models/app_localization.dart';
import 'package:h2s/models/language.dart';
import 'package:flutter/material.dart';
import 'package:h2s/services/authservice.dart';
import 'package:h2s/services/firebaseUserProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User? user;
  final formKey = GlobalKey<FormState>();
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  late String phoneNo, verificationId, smsCode;
  bool codeSent = false;

  @override
  void initState() {
    user = Provider.of<FirebaseUserProvider>(context, listen: false).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF3F51b5),
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 70),
              _topHeader(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.grey[50],
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40),
                      _labelText('Phone Number'),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).translate('Enter your phone number'),
                            prefixText: '+91',
                            prefixIcon: Icon(Icons.phone),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            setState(() {
                              phoneNo = '+91' + val;
                            });
                          },
                        ),
                      ),
                      codeSent
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 40),
                          _labelText('Enter OTP'),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context).translate('Enter OTP'),
                                prefixIcon: Icon(Icons.vpn_key),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  smsCode = val;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                          : Container(),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 46,
                          width: 160,
                          child: MaterialButton(
                            onPressed: () {
                              AuthService().savePhoneNumber(phoneNo);
                              if (codeSent) {
                                AuthService().signInWithOTP(smsCode, verificationId);
                              } else {
                                verifyPhone(phoneNo);
                              }
                              saveData();
                            },
                            child: codeSent
                                ? Text(
                              AppLocalizations.of(context).translate('Continue'),
                              style: TextStyle(fontSize: 20),
                            )
                                : Text(
                              AppLocalizations.of(context).translate('Verify'),
                              style: TextStyle(fontSize: 20),
                            ),
                            color: Color(0XFF303f9f),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment(0.9, -0.9),
                        child: DropdownButton(
                          underline: SizedBox(),
                          icon: Icon(Icons.language),
                          iconSize: 40,
                          items: Language.languageList()
                              .map<DropdownMenuItem>((lang) => DropdownMenuItem(
                            child: Text(lang.name),
                            value: lang,
                          ))
                              .toList(),
                          onChanged: (language) {
                            _changeLanguage(language);
                          },
                        ),
                      ),
                      SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(String phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed = (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
      setState(() {
        verificationId = verId;
        codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verified,
      verificationFailed: verificationfailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('Phone Number');
    if (user != null && phone != null) {
      await userCollection.doc(user!.uid).set({
        'phoneNumber': phone,
      });
    }
  }

  _labelText(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 24),
      child: Text(
        AppLocalizations.of(context).translate(title),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  void _changeLanguage(Language language) {
    Locale _temp=Locale('en', 'US');
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, 'US');
        break;
      case 'hi':
        _temp = Locale(language.languageCode, 'IN');
        break;
    }
    MyApp.setLocale(context, _temp);
  }

  _topHeader() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Create\nYour\nAccount'),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
          ),
          Image.asset(
            'assets/register.png',
            height: 170,
            fit: BoxFit.fitHeight,
          )
        ],
      ),
    );
  }
}
