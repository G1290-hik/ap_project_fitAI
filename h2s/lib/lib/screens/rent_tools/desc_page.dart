import 'package:flutter/material.dart';
import 'package:h2s/models/rent_tools_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DescPage extends StatelessWidget {
  final RentToolsModel rentToolsModel;

  const DescPage({Key? key, required this.rentToolsModel}) : super(key: key);

  Future<void> call(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 10),
              Image.network(
                rentToolsModel.toolImage.toString(),
                height: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              Text(
                rentToolsModel.toolName.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Price per Day: ${rentToolsModel.toolPricePerDay}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(rentToolsModel.toolDescription.toString()),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        call(rentToolsModel.ownerContactInfo.toString());
                      },
                      shape: StadiumBorder(),
                      color: Colors.blue,
                      child: Row(
                        children: [
                          Icon(Icons.call, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            "Contact",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    MaterialButton(
                      onPressed: () {},
                      shape: StadiumBorder(),
                      color: Colors.green,
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            "Book",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
