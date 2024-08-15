import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h2s/models/feed_model.dart';
import 'package:h2s/screens/feed/feed_template.dart';
import 'package:h2s/screens/weather/screens/homeScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              elevation: 4.0,
              color: Colors.grey,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => WHomescreen()));
              },
              child: Row(
                children: [
                  Text(
                    "Weather",
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cloud,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      //  AuthService().signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance.collection('feed').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot feed = snapshot.data.documents[index];
                      FeedModel feedModel = FeedModel.fromJson(feed.data as Map<String, dynamic>);
                      return FeedTemplate(feedModel: feedModel);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call),
        onPressed: () async {
          await launchUrl(Uri.parse('tel:18001801551'));
        },
      ),
    );
  }
}
