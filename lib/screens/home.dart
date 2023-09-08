import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/screens/orders.dart';
import 'package:midterms_coffee_app/screens/details.dart';
import 'package:midterms_coffee_app/config.dart';
import 'package:midterms_coffee_app/screens/cart.dart';
import 'package:midterms_coffee_app/screens/profile.dart';
import 'package:midterms_coffee_app/screens/rewards.dart';

import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> coffeeList = [
    "Americano",
    "Cappuchino",
    "Mocha",
    "Flat White"
  ];

  ProfileInfo _profile = ProfileInfo("", "", "", "");
  String userName = "Anderson";

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadLoyaltyCount();
  }

  Future<void> _loadProfile() async {
    ProfileInfo profile = await ProfileManager.getProfile();
    setState(() {
      _profile = profile;
    });
  }

  void navigateToProfilePage() async {
    // Navigate to the profile page and get the updated user name
    String? updatedName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(initialName: _profile.name),
      ),
    );

    if (updatedName != null) {
      // Update the user name on the home page if it's not null
      setState(() {
        userName = updatedName;
      });
    }
  }

  int loyaltyCount = 0;

  Future<void> _loadLoyaltyCount() async {
    int count = await Loyalty.getLoyaltyCount();
    setState(() {
      loyaltyCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primaryColor),
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Good morning",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(25, 0, 0, 0)),
                                  textAlign: TextAlign.left),
                              Text(userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left)
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Cart())),
                                  child: const Icon(Icons.shopping_cart)),
                              InkWell(
                                  onTap: () => navigateToProfilePage(),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: const Icon(Icons.person),
                                  ))
                            ],
                          ),
                        ],
                      ))),
                  LoyaltyCard(
                    loyaltyCount: loyaltyCount,
                  )
                ])),
            Expanded(
                child: Card(
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Choose your coffee",
                                style: TextStyle(color: Colors.white)),
                            for (var i = 0; i < coffeeList.length; i += 2)
                              Expanded(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Details(
                                                        coffee: Coffee(
                                                            coffeeList[i],
                                                            "assets/images/${coffeeList[i]}.png"))));
                                          },
                                          child: Card(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Image.asset(
                                                      "assets/images/${coffeeList[i]}.png"),
                                                  Text(coffeeList[i])
                                                ],
                                              )))),
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Details(
                                                        coffee: Coffee(
                                                            coffeeList[i + 1],
                                                            "assets/images/${coffeeList[i + 1]}.png"))));
                                          },
                                          child: Card(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Image.asset(
                                                      "assets/images/${coffeeList[i + 1]}.png"),
                                                  Text(coffeeList[i + 1])
                                                ],
                                              ))))
                                ],
                              )),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: bottomNav(context, 0))
                          ],
                        ))))
          ],
        ));
  }
}

Widget bottomNav(BuildContext context, int id) {
  return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: NavigationBar(
        selectedIndex: id,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront), label: "Home"),
          NavigationDestination(icon: Icon(Icons.redeem), label: "Rewards"),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: "Orders")
        ],
        onDestinationSelected: (id) {
          if (id == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          } else if (id == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Rewards(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Orders(),
              ),
            );
          }
        },
      ));
}

class LoyaltyCard extends StatelessWidget {
  int loyaltyCount;
  LoyaltyCard({required this.loyaltyCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.primaryColor,
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Loyalty card",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        "$loyaltyCount/${Loyalty.loyaltyTot}",
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              Card(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var i = 0;
                              i < min(loyaltyCount, Loyalty.loyaltyTot);
                              i++)
                            InkWell(
                                onTap: () {}, child: const Icon(Icons.coffee)),
                          for (var i = 0;
                              i < Loyalty.loyaltyTot - loyaltyCount;
                              i++)
                            InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.coffee,
                                  color: Colors.black12,
                                ))
                        ],
                      )))
            ],
          )),
    );
  }
}
