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
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '1 bitcoin: \$' + bitcoin.toString(),
                            style: TextStyle(fontSize: 18.0, color: Colors.red),
                          ),
                          Text(
                            '1 ethereum: \$' + ethereum.toString(),
                            style: TextStyle(fontSize: 18.0, color: Colors.red),
                          ),
                          Text(
                            '1 tether: \$' + tether.toString(),
                            style: TextStyle(fontSize: 18.0, color: Colors.red),
                          ),
                        ],
                      ),
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
