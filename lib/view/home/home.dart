import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String categoryType = "foods";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Column(
        children: [
          Container(
            height: size.height * .35,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.purple.shade200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Find the Best \nHealth For You",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ))
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 25),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: FaIcon(
                          FontAwesomeIcons.search,
                          color: Colors.purple.shade200,
                        ),
                        hintText: "Search",
                        border: InputBorder.none),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    categoryButton(FontAwesomeIcons.utensils, "Foods", "foods"),
                    categoryButton(FontAwesomeIcons.mugHot, "Drinks", "drinks"),
                    categoryButton(
                        FontAwesomeIcons.solidLemon, "Fruits", "fruits")
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection(categoryType).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GridView.count(
                crossAxisCount: snapshot.data!.docs.length,
                children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 95,
                            width: 95,
                            child: Image.network(document['imageUrl']),
                          ),
                          Padding(
                            padding: EdgeInsets.all(1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      document['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          document['price'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      Alert(
                                        context: context,
                                        type: AlertType.info,
                                        title: "Success",
                                        desc: "Added to favorites",
                                        buttons: [
                                          DialogButton(
                                            color: Colors.purple.shade300,
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            width: 120,
                                          )
                                        ],
                                      ).show();
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.heart,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget categoryButton(icon, name, type) {
    return InkWell(
      onTap: () {
        print(type);
        setState(() {
          categoryType = type;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FaIcon(icon),
              SizedBox(
                width: 5,
              ),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
