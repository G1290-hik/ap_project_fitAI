import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h2s/models/app_localization.dart';
import 'package:h2s/screens/Yield/yield.dart';
import 'package:h2s/screens/diseaseDetection/modalHelper.dart';
import 'package:h2s/screens/feed/feed_page.dart';
import 'package:h2s/screens/rent_tools/display_rent_tools.dart';
import 'package:h2s/services/authservice.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DisplayRentTools(),
    Disease(),
    Yield(),
    Placeholder(), // Replaced `connect()` with a placeholder widget
    Feed(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.limeAccent,
          title: Text(
            "Kisan Seva",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () async {
                AuthService().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthService().handleAuth()));
              },
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: AppLocalizations.of(context).translate("Tools"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist),
              label: AppLocalizations.of(context).translate("Diseases"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: AppLocalizations.of(context).translate("Yield"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: AppLocalizations.of(context).translate("Connect"),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.news_solid),
              label: AppLocalizations.of(context).translate("Feed"),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
