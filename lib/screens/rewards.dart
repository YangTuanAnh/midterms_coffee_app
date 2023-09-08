import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/config.dart';
import 'package:midterms_coffee_app/screens/home.dart';
import 'package:midterms_coffee_app/screens/redeem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Rewards extends StatefulWidget {
  const Rewards({super.key});
  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  int loyaltyCount = 0, loyaltyPoints = 0;
  List<History> historyItems = [];
  @override
  void initState() {
    super.initState();
    _loadLoyaltyCount();
    _loadLoyaltyPoints();
    _loadHistory();
  }

  void navigatetoRedeem() async {
    int? points = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Redeem()));
    if (points != null) setState(() => loyaltyPoints = points);
  }

  Future<void> _loadLoyaltyCount() async {
    int count = await Loyalty.getLoyaltyCount();
    setState(() {
      loyaltyCount = count;
    });
  }

  Future<void> _loadLoyaltyPoints() async {
    int count = await Loyalty.getLoyaltyPoints();
    setState(() {
      loyaltyPoints = count;
    });
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson = prefs.getStringList('history') ?? [];
    setState(() => historyItems = cartItemsJson.map((jsonString) {
          Map<String, dynamic> json = jsonDecode(jsonString);
          return History(json['name'], json['time'], json['points']);
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Rewards",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryColor)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primaryColor),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoyaltyCard(
                  loyaltyCount: loyaltyCount,
                ),
                Card(
                  color: AppColors.primaryColor,
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "My Points",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "$loyaltyPoints",
                                style: const TextStyle(
                                    fontSize: 28, color: Colors.white),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondaryColor),
                              onPressed: () => navigatetoRedeem(),
                              child: const Text("Redeem drinks"))
                        ],
                      )),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("History Rewards")),
                Expanded(
                  child: ListView.builder(
                    itemCount: historyItems.length,
                    itemBuilder: (context, index) {
                      final item = historyItems[index];
                      return ListTile(
                          leading:
                              Image.asset('assets/images/${item.name}.png'),
                          title: Text(item.name),
                          subtitle: Text(item.time),
                          trailing: Text("+${item.points.toString()}",
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor)));
                    },
                  ),
                ),
                bottomNav(context, 1),
              ],
            )));
  }
}
