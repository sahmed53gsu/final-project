import 'package:client/screens/authenticate/payment.dart';
import 'package:client/services/database.dart';
import 'package:client/shared/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({ Key? key }) : super(key: key);

  @override
  _WatchlistState createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      drawer: DrawerCommon(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('saveitems')
            // .orderBy('Date')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // var arr = snapshot.data!.docs.map((document) => document['Input']);
          else {
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return SizedBox(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(width: 2, color: Colors.green),
                    ),
                    color: Color(0xFFf1faee),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          // leading: Icon(Icons.podcasts_outlined),
                          // isThreeLine: true,
                          // tileColor: Color(0x55caf0f8),
                          title: Column(
                            children: [
                              SizedBox(
                                child: Image.network('${doc['imageURL']}',
                                    fit: BoxFit.contain),
                                height: MediaQuery.of(context).size.width * 0.8,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 20, 0, 5),
                                alignment: Alignment.topLeft,
                                // color: Colors.red,
                                child: Text(
                                  '${doc['Title']}',
                                  style: TextStyle(
                                    fontFamily: 'DaysOne',
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    // color: Color(0xFF29BF12),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                alignment: Alignment.topLeft,
                                // color: Colors.orange,
                                child: Text(
                                  '\$${doc['Price']}',
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Color(0xFF29BF12),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                alignment: Alignment.topLeft,
                                // color: Colors.yellow,
                                child: Text(
                                  'Description:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                alignment: Alignment.topLeft,
                                // color: Colors.yellow,
                                child: Text('${doc['Description']}'),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                alignment: Alignment.topLeft,
                                // color: Colors.yellow,
                                child: Text(
                                  'Seller:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                alignment: Alignment.topLeft,
                                // color: Colors.yellow,
                                child: Text('${doc['Seller']}'),
                              ),
                            ],
                          ),

                          // subtitle: Text(
                          //   "${doc['Username']}\n${doc['Date'].toString().substring(0, 10)} at ${doc['Date'].toString().substring(11, 16)}",
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     fontStyle: FontStyle.italic,
                          //     color: Color(0xFF0096c7),
                          //   ),
                          //   textAlign: TextAlign.left,
                          // ),
                          onTap: () {
                            alert(context, doc['Seller ID']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  void alert(context, uid) async {
    return showDialog(
      context: context,
      builder: (BuildContext bc) {
        return AlertDialog(
          title: Text(
            'Remove from watchlist?',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF29BF12),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                "No",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFe76f51),
                ),
              ),
            ),
            FlatButton(
              onPressed: () async {
                DocumentReference documentReference = FirebaseFirestore.instance.collection('saveitems').doc(uid);
                await FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                          transaction.delete(documentReference);
                        })
                        .then((value) => print("Deleted Listing"))
                        .catchError((error) => print("Failed delete listing"));
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF29BF12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}