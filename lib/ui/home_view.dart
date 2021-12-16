import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api_methods.dart';
import 'package:crypto_wallet/net/flutterfire.dart';
import 'package:crypto_wallet/ui/add_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;

  @override
  void initState() {
    getValues();
  }

  getValues() async {
    bitcoin = await getPrice("bitcoin");
    ethereum = await getPrice("ethereum");
    tether = await getPrice("tether");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValue(String id, double amount) {
      if (id == "bitcoin") {
        return bitcoin * amount;
      } else if (id == "ethereum") {
        return ethereum * amount;
      }
      return tether * amount;
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('Coins')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Stack(
                  children: [
                    HomeBackground(
                        bitcoin: bitcoin, tether: tether, ethereum: ethereum),
                    ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            height: MediaQuery.of(context).size.height / 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.blue),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 5.0),
                                Text(
                                  // limit to 2 decimal places
                                  "${document.get('Amount').toStringAsFixed(2)} ${document.id}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                Text(
                                    "\$${getValue(document.id, document.get('Amount')).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                IconButton(
                                    onPressed: () async {
                                      await removeCoin(document.id);
                                    },
                                    icon: const Icon(Icons.close,
                                        color: Colors.red))
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }),
        ),
      ),
      // route to new page to add new coins
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddView()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class HomeBackground extends StatelessWidget {
  const HomeBackground({
    Key? key,
    required this.bitcoin,
    required this.tether,
    required this.ethereum,
  }) : super(key: key);

  final double bitcoin;
  final double tether;
  final double ethereum;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            decoration: BoxDecoration(
                color: Colors.lightBlue.shade200.withOpacity(0.5)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '1 Bitcoin:',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '\$${bitcoin.toString()}',
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '1 Tether:',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.black54),
                        ),
                        Text(
                          '\$${tether.toString()}',
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '1 Ethereum:',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.black54),
                        ),
                        Text(
                          '\$${ethereum.toString()}',
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
