import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../auth/logIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import '../adminInterface/addActivity.dart';

class FindActivity extends StatefulWidget {
  const FindActivity({Key? key}) : super(key: key);

  @override
  _FindActivityState createState() => _FindActivityState();
}

class _FindActivityState extends State<FindActivity> {
  var db = FirebaseFirestore.instance;
  // lista aktywności
  List<QueryDocumentSnapshot>? activities;

  @override
  void initState() {
    super.initState();
    initializeActivities();
  }

  Future<void> initializeActivities() async {
    await getAllActivitiesData();
  }

  Future<void> getAllActivitiesData() async {
    try {
      QuerySnapshot querySnapshot =
      await db.collection("physicalActivities").get();
      setState(() {
        activities = querySnapshot.docs;
      });
    } catch (e) {
      print("Error retrieving activities: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Choose an activity'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'Log out':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoInScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Log out',
                child: Text('Log out'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20,),
          child: Column(
            children: [
              if (activities != null && activities!.length > 0)
                Column(
                  children: activities!.map((activity) {
                    var activityData = activity.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(activityData['activityName'], style: TextStyle(fontSize: 20)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(activityData['city'] + ', ' + activityData['street'] + ', ' + activityData['house'],  style: TextStyle(fontSize: 18)),
                                  Text('from: ' + activityData['activityPickedTimeStart'] + ' to: ' + activityData['activityPickedTimeEnd'],  style: TextStyle(fontSize: 18)),
                                  Text('Price: ' + activityData['price'].toString() + ' USD',  style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: const Text('See details'),
                                  onPressed: () {/* ... */},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (activities == null)
                Center(child: Text('No activities found', style: TextStyle(fontSize: 16))),
            ],
          ),
        ),
      ),
    );
  }
}
