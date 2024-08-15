import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h2s/main.dart';
import 'package:h2s/models/app_localization.dart';
import 'package:h2s/models/language.dart';
import 'package:h2s/models/rent_tools_model.dart';
import 'package:h2s/screens/rent_tools/display_rent_tools_ctrl.dart';
import 'package:h2s/screens/rent_tools/rent_tools_template.dart';
import 'package:h2s/services/authservice.dart';
import 'package:logger/logger.dart';

import 'add_new.dart';

class DisplayRentTools extends StatelessWidget {
  final displayRentToolsCtrl = Get.put(DisplayRentToolsCtrl());
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    void _changeLanguage(Language language) {
      Locale _temp;
      switch (language.languageCode) {
        case 'en':
          _temp = Locale(language.languageCode, 'US');
          break;
        case 'hi':
          _temp = Locale(language.languageCode, 'IN');
          break;
        default:
          _temp = Locale('en', 'US');
      }
      MyApp.setLocale(context, _temp);
    }

    return Scaffold(
      drawer: Drawer(
        child: Align(
          alignment: Alignment(0.9, -0.9),
          child: DropdownButton<Language>(
            underline: SizedBox(),
            icon: Icon(Icons.language, size: 40),
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>((Language lang) {
              return DropdownMenuItem<Language>(
                value: lang,
                child: Text(lang.name),
              );
            }).toList(),
            onChanged: (Language? language) {
              if (language != null) {
                _changeLanguage(language);
              }
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("Rent Tools")),
        actions: [
          DropdownButton<Language>(
            icon: Icon(Icons.language, color: Colors.white),
            underline: SizedBox(),
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>((Language lang) {
              return DropdownMenuItem<Language>(
                value: lang,
                child: Text(lang.name),
              );
            }).toList(),
            onChanged: (Language? language) {
              if (language != null) {
                _changeLanguage(language);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthService().handleAuth()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            _buildCategorySelector(context),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                displayRentToolsCtrl.selectedCategory.value;
                return StreamBuilder<QuerySnapshot>(
                  stream: displayRentToolsCtrl.rentToolsStrems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (snapshot.hasData) {
                      final tools = snapshot.data!.docs
                          .map((doc) => RentToolsModel.fromJson(doc.data() as Map<String, dynamic>))
                          .toList();
                      return ListView.builder(
                        itemCount: tools.length,
                        itemBuilder: (context, index) {
                          return RentToolsTemplate(rentToolsModel: tools[index]);
                        },
                      );
                    } else {
                      return Center(child: Text('No tools found.'));
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddItem()),
          );
        },
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Container(
      height: 75,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryButton(context, "All", "All"),
          _buildCategoryButton(context, "Tractors", "Tractors"),
          _buildCategoryButton(context, "Harvestors", "Harvestors"),
          _buildCategoryButton(context, "Pesticides", "Pesticides"),
          _buildCategoryButton(context, "Others", "Others"),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category, String translationKey) {
    return Container(
      width: 85,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.yellow,
      ),
      child: Center(
        child: TextButton(
          onPressed: () {
            displayRentToolsCtrl.selectedCategory.value = category;
            logger.d("Selected category: $category");
          },
          child: Obx(() => Text(
            AppLocalizations.of(context).translate(translationKey),
            style: displayRentToolsCtrl.selectedCategory.value == category
                ? TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                : TextStyle(color: Colors.green),
          )),
        ),
      ),
    );
  }
}
